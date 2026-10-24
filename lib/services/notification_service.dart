import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;
  StreamSubscription<String>? _registrationSubscription;
  StreamSubscription<User?>? _authSubscription;

  String? _latestInstallationId;

  bool _initialized = false;
  bool _localNotificationsInitialized = false;
  bool _timezoneInitialized = false;

  bool get isInitialized => _initialized;

  /// Emits Firebase Messaging registration identifiers.
  Stream<String> get onRegistered => _messaging.onRegistered;

  /// Requests Firebase Messaging registration.
  Future<void> register() => _messaging.register();

  /// Requests Firebase Messaging notification permissions.
  Future<NotificationSettings> requestPermission() {
    return _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  /// Initializes the device timezone for local notification scheduling.
  Future<void> _initializeTimezone() async {
    if (_timezoneInitialized) return;

    tz_data.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    _timezoneInitialized = true;
  }

  Future<void> initialize({
    void Function(String? payload)? onNotificationTap,
    void Function(String registrationId)? onRegistrationId,
  }) async {
    if (_initialized) return;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    try {
      await _initializeTimezone();

      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: (response) {
          onNotificationTap?.call(response.payload);
        },
      );

      _localNotificationsInitialized = true;
    } catch (error, stackTrace) {
      debugPrint('MOVIRA local notification initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    _foregroundSubscription ??= FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );

    _openedSubscription ??= FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
      onNotificationTap?.call(jsonEncode(message.data));
    });

    _registrationSubscription ??= _messaging.onRegistered.listen((
      installationId,
    ) {
      _latestInstallationId = installationId;

      onRegistrationId?.call(installationId);

      unawaited(_saveInstallationForCurrentUser(installationId));
    });

    _authSubscription ??= _auth.authStateChanges().listen((user) {
      final installationId = _latestInstallationId;

      if (user != null && installationId != null) {
        unawaited(_saveInstallationForUser(user.uid, installationId));
      }
    });

    try {
      await requestPermission();
    } catch (error, stackTrace) {
      debugPrint('MOVIRA notification permission request failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    try {
      await register();
    } catch (error, stackTrace) {
      debugPrint('MOVIRA Firebase Messaging registration failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    try {
      final initialMessage = await _messaging.getInitialMessage();

      if (initialMessage != null) {
        onNotificationTap?.call(jsonEncode(initialMessage.data));
      }
    } catch (error, stackTrace) {
      debugPrint('MOVIRA initial notification lookup failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    _initialized = true;
  }

  /// Schedules a one-time reminder before a departure.
  ///
  /// [id] must remain the same when replacing or cancelling this reminder.
  /// [departureDateTime] is interpreted in the device's local timezone.
  Future<void> scheduleDepartureReminder({
    required int id,
    required DateTime departureDateTime,
    required int leadTimeMinutes,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
  }) async {
    if (!_localNotificationsInitialized || !_timezoneInitialized) {
      throw StateError(
        'Local notifications are not initialized. '
        'Initialize NotificationService before scheduling.',
      );
    }

    if (id < 0) {
      throw ArgumentError.value(id, 'id', 'Must not be negative.');
    }

    if (leadTimeMinutes < 0 || leadTimeMinutes > 1440) {
      throw ArgumentError.value(
        leadTimeMinutes,
        'leadTimeMinutes',
        'Must be between 0 and 1440 minutes.',
      );
    }

    final departure = departureDateTime.isUtc
        ? departureDateTime.toLocal()
        : departureDateTime;

    final reminderTime = departure.subtract(Duration(minutes: leadTimeMinutes));

    if (!reminderTime.isAfter(DateTime.now())) {
      throw ArgumentError(
        'The reminder time must be in the future. '
        'Choose a later departure time or a shorter lead time.',
      );
    }

    final scheduledDate = tz.TZDateTime.from(reminderTime, tz.local);

    await _localNotifications.zonedSchedule(
      id: id,
      title: 'MOVIRA Trip Reminder',
      body: leadTimeMinutes == 0
          ? 'Your scheduled departure time is approaching.'
          : 'Your departure is in $leadTimeMinutes minutes.',
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'movira_departure_reminders',
          'Departure reminders',
          channelDescription: 'Reminders for scheduled MOVIRA trip departures.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: soundEnabled,
          enableVibration: vibrationEnabled,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: soundEnabled,
          presentBadge: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: jsonEncode({
        'type': 'departure_reminder',
        'reminderId': id,
        'departureDateTime': departure.toIso8601String(),
      }),
    );
  }

  /// Cancels a previously scheduled departure reminder.
  Future<void> cancelDepartureReminder(int id) async {
    await _localNotifications.cancel(id: id);
  }

  /// Cancels all pending local notifications.
  ///
  /// Use only when the user explicitly requests cancellation of all reminders.
  Future<void> cancelAllLocalNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<void> _saveInstallationForCurrentUser(String installationId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _saveInstallationForUser(user.uid, installationId);
  }

  Future<void> _saveInstallationForUser(
    String uid,
    String installationId,
  ) async {
    final platform = switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => 'other',
    };

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(installationId)
          .set({
            'installationId': installationId,
            'platform': platform,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (error, stackTrace) {
      debugPrint('MOVIRA device registration persistence failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      await _showForegroundNotification(message);
    } catch (error, stackTrace) {
      debugPrint('MOVIRA foreground notification failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    if (!_localNotificationsInitialized) return;

    final title =
        message.notification?.title ?? message.data['title']?.toString();

    final body = message.notification?.body ?? message.data['body']?.toString();

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    await _localNotifications.show(
      id: message.messageId?.hashCode ?? message.hashCode,
      title: title ?? 'MOVIRA Travel Alert',
      body: body ?? '',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'movira_travel_alerts',
          'Travel alerts',
          channelDescription: 'MOVIRA trip updates and travel notifications.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _openedSubscription?.cancel();
    await _registrationSubscription?.cancel();
    await _authSubscription?.cancel();

    _foregroundSubscription = null;
    _openedSubscription = null;
    _registrationSubscription = null;
    _authSubscription = null;

    _latestInstallationId = null;
    _initialized = false;
    _localNotificationsInitialized = false;
    _timezoneInitialized = false;
  }
}
