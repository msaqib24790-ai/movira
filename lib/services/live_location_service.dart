import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class LiveLocationService {
  LiveLocationService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  StreamSubscription<Position>? _positionSubscription;

  bool get isSharing => _positionSubscription != null;

  Future<bool> isDriverAssignedToTrip(String tripId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final authorization = await _firestore
        .collection('driverAuthorizations')
        .doc(user.uid)
        .get();

    if (authorization.data()?['authorized'] != true ||
        authorization.data()?['active'] != true) {
      return false;
    }

    final trip = await _firestore.collection('activeTrips').doc(tripId).get();

    final data = trip.data();

    return trip.exists &&
        data?['assignedDriverUid'] == user.uid &&
        data?['status'] == 'active';
  }

  Future<void> startDriverSharing(
    String tripId, {
    void Function(Object error)? onSharingError,
  }) async {
    if (_positionSubscription != null) {
      throw StateError('Location sharing is already running.');
    }

    if (!await isDriverAssignedToTrip(tripId)) {
      throw StateError(
        'This account is not authorized for the selected active trip.',
      );
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError('Please enable the device location service.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('Location permission is unavailable.');
    }

    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen(
          (position) async {
            try {
              await _firestore.collection('liveLocations').doc(tripId).set({
                'latitude': position.latitude,
                'longitude': position.longitude,
                'accuracy': position.accuracy,
                'updatedAt': FieldValue.serverTimestamp(),
              });
            } catch (error) {
              onSharingError?.call(error);
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            onSharingError?.call(error);
          },
        );
  }

  Future<void> stopDriverSharing() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Stream<Map<String, dynamic>?> watchLiveLocation(String tripId) {
    return _firestore.collection('liveLocations').doc(tripId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return null;
      return snapshot.data();
    });
  }
}
