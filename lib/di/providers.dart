import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/data/datasource/local/db_manager.dart';
import 'package:music_player/data/datasource/local/db_manager_impl.dart';
import 'package:music_player/data/datasource/remote/firebase_service.dart';
import 'package:music_player/data/datasource/remote/firebase_service_impl.dart';
import 'package:music_player/data/repository/user_repository_impl.dart';
import 'package:music_player/domain/repository/user_repository.dart';

/// Firebase

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/// Data Source - Local & Remote

final dbManagerProvider =
    Provider.autoDispose<DbManager>((ref) => DbManagerImpl());


final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final firebaseFirestore = ref.read(firebaseFirestoreProvider);
  return FirebaseServiceImpl(firebaseAuth, firebaseFirestore);
});

/// Repository

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  final dbManager = ref.read(dbManagerProvider);
  return UserRepositoryImpl(firebaseService, dbManager);
});

