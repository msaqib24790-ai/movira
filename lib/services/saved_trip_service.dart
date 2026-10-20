
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedTripService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static User _requireSignedInUser() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw StateError(
        'Please sign in to manage saved trips.',
      );
    }

    return user;
  }

  // Reference to the current user's saved trips.
  static CollectionReference<Map<String, dynamic>> _savedTripsRef(
      String uid,
      ) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('savedTrips');
  }

  // Saves a planned trip and returns its Firestore document ID.
  static Future<String> saveTrip({
    required String from,
    required String to,
  }) async {
    final user = _requireSignedInUser();

    final origin = from.trim();
    final destination = to.trim();

    if (origin.isEmpty || destination.isEmpty) {
      throw ArgumentError(
        'Departure and destination are required.',
      );
    }

    if (origin.toLowerCase() == destination.toLowerCase()) {
      throw ArgumentError(
        'Departure and destination must be different.',
      );
    }

    final document = _savedTripsRef(user.uid).doc();

    await document.set({
      'tripId': document.id,
      'userId': user.uid,
      'from': origin,
      'to': destination,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return document.id;
  }

  // Retrieves the current user's saved trips.
  static Future<List<Map<String, dynamic>>> getSavedTrips() async {
    final user = _requireSignedInUser();

    final snapshot = await _savedTripsRef(user.uid).get();

    final trips = snapshot.docs.map((document) {
      return <String, dynamic>{
        ...document.data(),
        'tripId': document.id,
      };
    }).toList();

    // Sort newest first. Missing timestamps are placed last.
    trips.sort((a, b) {
      final aTime = a['createdAt'];
      final bTime = b['createdAt'];

      if (aTime is! Timestamp && bTime is! Timestamp) {
        return 0;
      }

      if (aTime is! Timestamp) return 1;
      if (bTime is! Timestamp) return -1;

      return bTime.compareTo(aTime);
    });

    return trips;
  }

  // Updates the departure and destination of an existing saved trip.
  static Future<void> updateSavedTrip({
    required String tripId,
    required String from,
    required String to,
  }) async {
    final user = _requireSignedInUser();

    final id = tripId.trim();
    final origin = from.trim();
    final destination = to.trim();

    if (id.isEmpty) {
      throw ArgumentError(
        'A valid trip ID is required.',
      );
    }

    if (origin.isEmpty || destination.isEmpty) {
      throw ArgumentError(
        'Departure and destination are required.',
      );
    }

    if (origin.toLowerCase() == destination.toLowerCase()) {
      throw ArgumentError(
        'Departure and destination must be different.',
      );
    }

    await _savedTripsRef(user.uid).doc(id).update({
      'from': origin,
      'to': destination,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Removes a saved trip belonging to the current user.
  static Future<void> removeSavedTrip({
    required String tripId,
  }) async {
    final user = _requireSignedInUser();
    final id = tripId.trim();

    if (id.isEmpty) {
      throw ArgumentError(
        'A valid trip ID is required.',
      );
    }

    await _savedTripsRef(user.uid).doc(id).delete();
  }
}
