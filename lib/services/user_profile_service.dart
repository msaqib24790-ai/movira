
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// Creates a user profile or updates an existing profile.
  static Future<void> createOrUpdateProfile({
    required User user,
    String? phone,
  }) async {
    final DocumentReference<Map<String, dynamic>> userRef =
    _firestore.collection('users').doc(user.uid);

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await userRef.get();

    final Map<String, dynamic> existingData =
        snapshot.data() ?? <String, dynamic>{};

    final String suppliedName = user.displayName?.trim() ?? '';
    final String suppliedEmail = user.email?.trim() ?? '';
    final String suppliedPhone = phone?.trim() ?? '';

    final Map<String, dynamic> data = {
      'uid': user.uid,
      'name': suppliedName.isNotEmpty
          ? suppliedName
          : existingData['name'] ?? '',
      'email': suppliedEmail.isNotEmpty
          ? suppliedEmail
          : existingData['email'] ?? '',
      'phone': suppliedPhone.isNotEmpty
          ? suppliedPhone
          : existingData['phone'] ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Set createdAt only when creating a new profile.
    if (!snapshot.exists) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await userRef.set(
      data,
      SetOptions(merge: true),
    );
  }

  /// Retrieves a user's profile from Firestore.
  static Future<Map<String, dynamic>?> getProfile(
      String uid,
      ) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }
}
