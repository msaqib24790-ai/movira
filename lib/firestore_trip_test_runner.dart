
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'services/saved_trip_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('FAIL: No signed-in user found.');
      return;
    }

    print('Signed-in UID: ${user.uid}');

    // Create a separate test trip.
    final tripId = await SavedTripService.saveTrip(
      from: 'UPDATE_TEST_ORIGIN',
      to: 'UPDATE_TEST_DESTINATION',
    );

    print('PASS: Test trip created. ID: $tripId');

    // Update only this newly created test trip.
    await SavedTripService.updateSavedTrip(
      tripId: tripId,
      from: 'UPDATED_TEST_ORIGIN',
      to: 'UPDATED_TEST_DESTINATION',
    );

    print('PASS: Update operation completed.');

    // Read back and verify the updated values.
    final trips = await SavedTripService.getSavedTrips();

    final matches = trips.where(
          (trip) => trip['tripId'] == tripId,
    );

    if (matches.isNotEmpty &&
        matches.first['from'] == 'UPDATED_TEST_ORIGIN' &&
        matches.first['to'] == 'UPDATED_TEST_DESTINATION') {
      print('PASS: Updated values verified in Firestore.');
    } else {
      print('FAIL: Updated values could not be verified.');
      return;
    }

    // Clean up only the test trip created by this run.
    await SavedTripService.removeSavedTrip(
      tripId: tripId,
    );

    print('PASS: Test trip cleaned up.');
  } catch (error, stackTrace) {
    print('FAIL: $error');
    print(stackTrace);
  }
}
