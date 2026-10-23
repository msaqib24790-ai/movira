import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movira/services/support_service.dart';

class MockAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}

void main() {
  late FakeFirebaseFirestore firestore;
  late MockAuth auth;
  late MockUser user;
  late SupportService service;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    auth = MockAuth();
    user = MockUser();

    when(() => user.uid).thenReturn('test-user-123');
    when(() => auth.currentUser).thenReturn(user);

    service = SupportService(firestore: firestore, auth: auth);
  });

  test('submits a valid feedback request with the signed-in user ID',
      () async {
    final id = await service.submitRequest(
      type: 'feedback',
      title: ' App feedback ',
      description: ' The route details are helpful. ',
      details: const {'source': 'test'},
      rating: 5,
    );

    expect(id, isNotEmpty);

    final snapshot =
        await firestore.collection('supportTickets').doc(id).get();
    final data = snapshot.data()!;

    expect(data['userId'], 'test-user-123');
    expect(data['type'], 'feedback');
    expect(data['title'], 'App feedback');
    expect(data['description'], 'The route details are helpful.');
    expect(data['status'], 'open');
    expect(data['details'], {'source': 'test'});
    expect(data['rating'], 5);
    expect(data['createdAt'], isA<Timestamp>());
    expect(data['updatedAt'], isA<Timestamp>());
  });

  test('normalizes request type and trims text fields', () async {
    final id = await service.submitRequest(
      type: ' ISSUE ',
      title: ' Bus stop issue ',
      description: ' Stop sign is damaged. ',
    );

    final snapshot =
        await firestore.collection('supportTickets').doc(id).get();
    final data = snapshot.data()!;

    expect(data['type'], 'issue');
    expect(data['title'], 'Bus stop issue');
    expect(data['description'], 'Stop sign is damaged.');
  });

  test('ticket query is scoped to the signed-in user and newest first',
      () async {
    final tickets = firestore.collection('supportTickets');

    await tickets.add({
      'userId': 'test-user-123',
      'type': 'ticket',
      'title': 'My ticket',
      'description': 'Test ticket',
      'status': 'open',
      'details': <String, dynamic>{},
      'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
    });

    await tickets.add({
      'userId': 'another-user',
      'type': 'ticket',
      'title': 'Other user ticket',
      'description': 'Must not be returned',
      'status': 'open',
      'details': <String, dynamic>{},
      'createdAt': Timestamp.fromDate(DateTime(2026, 1, 2)),
    });

    final requests = await service.watchMyRequests().first;

    expect(requests, hasLength(1));
    expect(requests.single['userId'], 'test-user-123');
    expect(requests.single['title'], 'My ticket');
  });
}
