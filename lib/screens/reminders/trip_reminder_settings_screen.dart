import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/notification_service.dart';

class TripReminderSettingsScreen extends StatefulWidget {
  const TripReminderSettingsScreen({super.key});

  @override
  State<TripReminderSettingsScreen> createState() =>
      _TripReminderSettingsScreenState();
}

class _TripReminderSettingsScreenState
    extends State<TripReminderSettingsScreen> {
  static const Color navy = Color(0xFF071B2C);
  static const Color navySoft = Color(0xFF123247);
  static const Color teal = Color(0xFF00C7B7);
  static const Color cyan = Color(0xFF21D4FD);
  static const Color ice = Color(0xFFF4FBFD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softCyan = Color(0xFFDDFBFA);
  static const Color textDark = Color(0xFF12212D);
  static const Color textMuted = Color(0xFF6B7C88);
  static const Color lightBorder = Color(0xFFE1EDF1);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);

  static const int _notificationId = 5101;

  bool _tripReminders = true;
  bool _departureAlerts = true;
  bool _delayAlerts = true;
  bool _stopAlerts = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _isLoading = true;
  bool _isSaving = false;

  int _selectedLeadTime = 1;
  int _selectedRepeat = 0;

  DateTime _departureDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _departureTime = const TimeOfDay(hour: 9, minute: 0);

  final List<String> _leadTimes = ['5 min', '10 min', '15 min', '30 min'];

  final List<int> _leadTimeMinutes = [5, 10, 15, 30];

  final List<String> _repeatOptions = ['Once', 'Daily', 'Weekdays', 'Custom'];

  DocumentReference<Map<String, dynamic>>? get _settingsReference {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reminderSettings')
        .doc('preferences');
  }

  DateTime get _departureDateTime => DateTime(
    _departureDate.year,
    _departureDate.month,
    _departureDate.day,
    _departureTime.hour,
    _departureTime.minute,
  );

  DateTime get _reminderDateTime => _departureDateTime.subtract(
    Duration(minutes: _leadTimeMinutes[_selectedLeadTime]),
  );

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final reference = _settingsReference;

      if (reference != null) {
        final snapshot = await reference.get();

        if (snapshot.exists && mounted) {
          final data = snapshot.data()!;

          final savedDeparture = data['departureDateTime'];
          DateTime? parsedDeparture;

          if (savedDeparture is Timestamp) {
            parsedDeparture = savedDeparture.toDate().toLocal();
          } else if (savedDeparture is String) {
            parsedDeparture = DateTime.tryParse(savedDeparture)?.toLocal();
          }

          setState(() {
            _tripReminders = data['tripRemindersEnabled'] as bool? ?? true;
            _departureAlerts = data['departureAlertsEnabled'] as bool? ?? true;
            _delayAlerts = data['delayAlertsEnabled'] as bool? ?? true;
            _stopAlerts = data['stopAlertsEnabled'] as bool? ?? false;
            _soundEnabled = data['soundEnabled'] as bool? ?? true;
            _vibrationEnabled = data['vibrationEnabled'] as bool? ?? true;

            final savedLeadTime = data['leadTimeMinutes'];
            final leadIndex = _leadTimeMinutes.indexOf(
              savedLeadTime is int ? savedLeadTime : 10,
            );
            _selectedLeadTime = leadIndex >= 0 ? leadIndex : 1;

            final savedRepeat = data['repeatOption'];
            final repeatIndex = _repeatOptions.indexOf(
              savedRepeat is String ? savedRepeat : 'Once',
            );
            _selectedRepeat = repeatIndex >= 0 ? repeatIndex : 0;

            if (parsedDeparture != null) {
              _departureDate = DateTime(
                parsedDeparture.year,
                parsedDeparture.month,
                parsedDeparture.day,
              );
              _departureTime = TimeOfDay.fromDateTime(parsedDeparture);
            }
          });
        }
      }
    } catch (error) {
      if (mounted) {
        _showMessage(
          'Could not load saved settings. Check your connection and try again.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _chooseDepartureDate() async {
    final now = DateTime.now();
    final initialDate =
        _departureDate.isBefore(DateTime(now.year, now.month, now.day))
        ? now
        : _departureDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
      helpText: 'Select departure date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: navy,
              secondary: teal,
              surface: white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => _departureDate = picked);
    }
  }

  Future<void> _chooseDepartureTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _departureTime,
      helpText: 'Select departure time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: navy,
              secondary: teal,
              surface: white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => _departureTime = picked);
    }
  }

  Future<void> _saveSettings() async {
    if (_isSaving) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(
        'Please sign in to save your reminder settings.',
        isError: true,
      );
      return;
    }

    final departure = _departureDateTime;
    final reminder = _reminderDateTime;

    if (_tripReminders &&
        _departureAlerts &&
        !reminder.isAfter(DateTime.now())) {
      _showMessage(
        'Choose a future departure time. The selected reminder time has '
        'already passed.',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final reference = _settingsReference!;

      await reference.set({
        'tripRemindersEnabled': _tripReminders,
        'departureAlertsEnabled': _departureAlerts,
        'delayAlertsEnabled': _delayAlerts,
        'stopAlertsEnabled': _stopAlerts,
        'soundEnabled': _soundEnabled,
        'vibrationEnabled': _vibrationEnabled,
        'leadTimeMinutes': _leadTimeMinutes[_selectedLeadTime],
        'repeatOption': _repeatOptions[_selectedRepeat],
        'departureDateTime': Timestamp.fromDate(departure),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (_tripReminders && _departureAlerts) {
        await NotificationService.instance.scheduleDepartureReminder(
          id: _notificationId,
          departureDateTime: departure,
          leadTimeMinutes: _leadTimeMinutes[_selectedLeadTime],
          soundEnabled: _soundEnabled,
          vibrationEnabled: _vibrationEnabled,
        );
      } else {
        await NotificationService.instance.cancelDepartureReminder(
          _notificationId,
        );
      }

      if (!mounted) return;

      final repeatMessage = _selectedRepeat == 0
          ? 'One-time departure reminder scheduled.'
          : 'Settings saved. Only a one-time departure reminder is '
                'currently scheduled; recurring reminders are not active.';

      _showMessage(
        _tripReminders && _departureAlerts
            ? repeatMessage
            : 'Settings saved. Departure reminder is disabled.',
      );
    } catch (error) {
      if (mounted) {
        _showMessage(
          'Could not save or schedule the reminder. Check notification '
          'permissions and your connection, then try again.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? const Color(0xFFB42318) : navy,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _ReminderBackground(),
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: teal))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildHero(),
                        const SizedBox(height: 24),
                        _buildMasterToggle(),
                        const SizedBox(height: 24),
                        _sectionTitle(
                          'Departure Schedule',
                          'Choose the date and time for your journey',
                        ),
                        const SizedBox(height: 14),
                        _buildDepartureScheduleCard(),
                        const SizedBox(height: 24),
                        _sectionTitle(
                          'Reminder Timing',
                          'Choose how early MOVIRA should remind you',
                        ),
                        const SizedBox(height: 14),
                        _buildLeadTimeSelector(),
                        const SizedBox(height: 24),
                        _sectionTitle(
                          'Trip Alerts',
                          'Choose which travel updates you want',
                        ),
                        const SizedBox(height: 14),
                        _buildTripAlertsCard(),
                        const SizedBox(height: 24),
                        _sectionTitle(
                          'Repeat Reminder',
                          'Choose your preferred reminder frequency',
                        ),
                        const SizedBox(height: 14),
                        _buildRepeatSelector(),
                        const SizedBox(height: 24),
                        _sectionTitle(
                          'Notification Style',
                          'Control sound and vibration',
                        ),
                        const SizedBox(height: 14),
                        _buildNotificationStyleCard(),
                        const SizedBox(height: 24),
                        _buildNextReminderPreview(),
                        const SizedBox(height: 24),
                        _buildSaveButton(),
                        const SizedBox(height: 14),
                        _buildAvailabilityNote(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: lightBorder),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: navy),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: lightBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/branding/movira_icon.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TRIP REMINDERS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Stay ready for every journey',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: softCyan,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.alarm_rounded, color: teal),
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navy, navySoft, Color(0xFF15516A)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22071B2C),
            blurRadius: 20,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [teal, cyan]),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: navy,
              size: 31,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Never miss your bus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Schedule a departure reminder and choose how MOVIRA '
                  'should notify you.',
                  style: TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 11.5,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterToggle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _tripReminders ? teal.withOpacity(0.28) : lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _tripReminders ? softCyan : const Color(0xFFF3F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _tripReminders ? Icons.alarm_on_rounded : Icons.alarm_off_rounded,
              color: _tripReminders ? teal : textMuted,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Reminders',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Enable reminders for your planned journeys',
                  style: TextStyle(color: textMuted, fontSize: 10.8),
                ),
              ],
            ),
          ),
          Switch(
            value: _tripReminders,
            onChanged: (value) => setState(() => _tripReminders = value),
            activeColor: teal,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: textMuted, fontSize: 11.5),
        ),
      ],
    );
  }

  Widget _buildDepartureScheduleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          _pickerRow(
            icon: Icons.calendar_month_rounded,
            title: 'Departure date',
            value:
                '${_departureDate.day.toString().padLeft(2, '0')}/'
                '${_departureDate.month.toString().padLeft(2, '0')}/'
                '${_departureDate.year}',
            onTap: _chooseDepartureDate,
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _pickerRow(
            icon: Icons.schedule_rounded,
            title: 'Departure time',
            value: _departureTime.format(context),
            onTap: _chooseDepartureTime,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ice,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active_outlined, color: teal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Planned reminder: ${_formatDateTime(_reminderDateTime)}',
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickerRow({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: softCyan,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: textMuted, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_calendar_rounded, color: navy, size: 20),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final date =
        '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';
    final time = TimeOfDay.fromDateTime(dateTime).format(context);
    return '$date at $time';
  }

  Widget _buildLeadTimeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(_leadTimes.length, (index) {
        final selected = _selectedLeadTime == index;

        return GestureDetector(
          onTap: () => setState(() => _selectedLeadTime = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(
              color: selected ? navy : white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? navy : lightBorder),
            ),
            child: Text(
              _leadTimes[index],
              style: TextStyle(
                color: selected ? Colors.white : textDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTripAlertsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          _settingRow(
            icon: Icons.directions_bus_rounded,
            title: 'Departure alerts',
            subtitle: 'Notify before your bus leaves',
            value: _departureAlerts,
            color: cyan,
            onChanged: (value) => setState(() => _departureAlerts = value),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _settingRow(
            icon: Icons.warning_amber_rounded,
            title: 'Delay alerts',
            subtitle: 'Preferences only; live delay data is not connected',
            value: _delayAlerts,
            color: warning,
            onChanged: (value) => setState(() => _delayAlerts = value),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _settingRow(
            icon: Icons.pin_drop_rounded,
            title: 'Stop alerts',
            subtitle: 'Preferences only; destination tracking is not connected',
            value: _stopAlerts,
            color: success,
            onChanged: (value) => setState(() => _stopAlerts = value),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatSelector() {
    return Column(
      children: List.generate(_repeatOptions.length, (index) {
        final selected = _selectedRepeat == index;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _repeatOptions.length - 1 ? 0 : 10,
          ),
          child: GestureDetector(
            onTap: () => setState(() => _selectedRepeat = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: selected ? softCyan : white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? teal.withOpacity(0.30) : lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? teal : textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _repeatOptions[index],
                    style: TextStyle(
                      color: selected ? textDark : textMuted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  if (index == 3)
                    const Icon(Icons.chevron_right_rounded, color: textMuted),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNotificationStyleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          _settingRow(
            icon: Icons.volume_up_rounded,
            title: 'Sound',
            subtitle: 'Play sound with reminder',
            value: _soundEnabled,
            color: teal,
            onChanged: (value) => setState(() => _soundEnabled = value),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _settingRow(
            icon: Icons.vibration_rounded,
            title: 'Vibration',
            subtitle: 'Vibrate when reminder arrives',
            value: _vibrationEnabled,
            color: const Color(0xFF8B5CF6),
            onChanged: (value) => setState(() => _vibrationEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _settingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 10.5,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: teal),
      ],
    );
  }

  Widget _buildNextReminderPreview() {
    final enabled = _tripReminders && _departureAlerts;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C3247), Color(0xFF0B2235)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cyan.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.schedule_send_rounded, color: cyan),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Reminder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  enabled
                      ? '${_formatDateTime(_reminderDateTime)} • '
                            '${_leadTimes[_selectedLeadTime]} before departure'
                      : 'Trip departure reminders are disabled',
                  style: const TextStyle(
                    color: Color(0xFFB8D8E8),
                    fontSize: 10.8,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Repeat preference: ${_repeatOptions[_selectedRepeat]}',
                  style: const TextStyle(
                    color: Color(0xFFB8D8E8),
                    fontSize: 10.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightBorder),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: teal, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Departure reminders use your selected schedule. Delay alerts '
              'and destination alerts will need live delay information or '
              'location-based tracking before they can notify you.',
              style: TextStyle(color: textMuted, fontSize: 11, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [teal, cyan]),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3000C7B7),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _isSaving ? null : _saveSettings,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSaving)
                const SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: navy,
                  ),
                )
              else
                const Icon(Icons.check_circle_rounded, color: navy, size: 21),
              const SizedBox(width: 10),
              Text(
                _isSaving ? 'Saving Settings...' : 'Save Reminder Settings',
                style: const TextStyle(
                  color: navy,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderBackground extends StatelessWidget {
  const _ReminderBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF9FDFF), Color(0xFFF0FAFD), Color(0xFFF7FCFD)],
            ),
          ),
        ),
        Positioned(
          top: -110,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF21D4FD).withOpacity(0.09),
            ),
          ),
        ),
        Positioned(
          bottom: -130,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C7B7).withOpacity(0.07),
            ),
          ),
        ),
      ],
    );
  }
}
