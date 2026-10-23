import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movira/services/support_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements User {}

void main() {
  late MockFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late SupportService service;

  setUp(() {
    firestore = MockFirebaseFirestore();
    auth = MockFirebaseAuth();

    when(() => auth.currentUser).thenReturn(null);

    service = SupportService(
      firestore: firestore,
      auth: auth,
    );
  });

  void signInForTest() {
    final user = MockFirebaseUser();
    when(() => user.uid).thenReturn('test-user-123');
    when(() => auth.currentUser).thenReturn(user);
  }

  group('SupportService signed-out behavior', () {
    test('rejects ticket submission when signed out', () async {
      await expectLater(
        service.submitRequest(
          type: 'ticket',
          title: 'Test ticket',
          description: 'Testing signed-out behavior',
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('Please sign in'),
          ),
        ),
      );
    });

    test('emits an error when watching requests while signed out', () async {
      await expectLater(
        service.watchMyRequests(),
        emitsError(isA<StateError>()),
      );
    });
  });

  group('SupportService request validation', () {
    test('rejects unsupported request types', () async {
      signInForTest();

      await expectLater(
        service.submitRequest(
          type: 'unknown',
          title: 'Test request',
          description: 'Test description',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects an empty title', () async {
      signInForTest();

      await expectLater(
        service.submitRequest(
          type: 'ticket',
          title: '   ',
          description: 'Test description',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects an empty description', () async {
      signInForTest();

      await expectLater(
        service.submitRequest(
          type: 'ticket',
          title: 'Test title',
          description: '   ',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects titles longer than 160 characters', () async {
      signInForTest();

      await expectLater(
        service.submitRequest(
          type: 'ticket',
          title: 'T' * 161,
          description: 'Test description',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects descriptions longer than 5000 characters', () async {
      signInForTest();

      await expectLater(
        service.submitRequest(
          type: 'ticket',
          title: 'Test title',
          description: 'D' * 5001,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects ratings below 1', () async {
      signInForTest();

      await expectLater(
        service.submitRequest(
          type: 'feedback',
          title: 'Test feedback',
          description: 'Test description',
          rating: 0,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('rejects ratings above 5', () async {
      signInForTest();

      await expectLater(
        service.submitRequest(
          type: 'feedback',
          title: 'Test feedback',
          description: 'Test description',
          rating: 6,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
