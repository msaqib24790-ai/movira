import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firestore operations for authenticated MOVIRA support requests.
///
/// Required Firestore rules for `supportTickets` must be deployed
/// and verified before these methods are used in production.
class SupportService {
  SupportService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _tickets =>
      _firestore.collection('supportTickets');

  String _requireUserId() {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Please sign in to submit or view support requests.');
    }

    return user.uid;
  }

  /// Creates a support request owned by the currently signed-in user.
  ///
  /// Supported types: ticket, issue, lost_item, feedback.
  Future<String> submitRequest({
    required String type,
    required String title,
    required String description,
    Map<String, dynamic> details = const <String, dynamic>{},
    int? rating,
  }) async {
    final userId = _requireUserId();

    final normalizedType = type.trim().toLowerCase();
    final normalizedTitle = title.trim();
    final normalizedDescription = description.trim();

    const allowedTypes = <String>{'ticket', 'issue', 'lost_item', 'feedback'};

    if (!allowedTypes.contains(normalizedType)) {
      throw ArgumentError.value(type, 'type', 'Unsupported request type.');
    }

    if (normalizedTitle.isEmpty) {
      throw ArgumentError('A title is required.');
    }

    if (normalizedDescription.isEmpty) {
      throw ArgumentError('A description is required.');
    }

    if (normalizedTitle.length > 160) {
      throw ArgumentError('The title must be 160 characters or fewer.');
    }

    if (normalizedDescription.length > 5000) {
      throw ArgumentError('The description must be 5000 characters or fewer.');
    }

    if (rating != null && (rating < 1 || rating > 5)) {
      throw ArgumentError.value(
        rating,
        'rating',
        'Rating must be from 1 to 5.',
      );
    }

    final requestData = <String, dynamic>{
      'userId': userId,
      'type': normalizedType,
      'title': normalizedTitle,
      'description': normalizedDescription,
      'status': 'open',
      'details': details,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (rating != null) {
      requestData['rating'] = rating;
    }

    final reference = await _tickets.add(requestData);
    return reference.id;
  }

  /// Watches the signed-in user's support requests, newest first.
  ///
  /// If nobody is signed in, returns an error stream instead of throwing
  /// synchronously while the screen is building.
  ///
  /// Firestore rules must restrict access to the request owner.
  Stream<List<Map<String, dynamic>>> watchMyRequests() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream<List<Map<String, dynamic>>>.error(
        StateError('Please sign in to view support requests.'),
      );
    }

    return _tickets
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return <String, dynamic>{'id': doc.id, ...doc.data()};
          }).toList(),
        );
  }
}
