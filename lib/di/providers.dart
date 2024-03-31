

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/data/datasource/remote/firebase_service.dart';
import 'package:music_player/data/datasource/remote/firebase_service_impl.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);


final authServiceProvider = Provider<FirebaseService>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final firebaseFirestore = ref.read(firebaseFirestoreProvider);
  return FirebaseServiceImpl(firebaseAuth, firebaseFirestore);
});