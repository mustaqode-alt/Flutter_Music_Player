

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:music_player/data/datasource/remote/firebase_service_impl.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<void> signOut() async {
    return Future.value();
  }
}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseServiceImpl extends Mock implements FirebaseServiceImpl {}

void main() {
  group('FirebaseServiceImpl', () {
    late FirebaseServiceImpl firebaseService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseFirestore mockFirebaseFirestore;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseFirestore = MockFirebaseFirestore();
      firebaseService = FirebaseServiceImpl(mockFirebaseAuth, mockFirebaseFirestore);
    });

    test('logout should call signOut', () async {
      await firebaseService.logout();

      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}
