import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/data/datasource/remote/firebase_service.dart';
import 'package:music_player/domain/entity/user_data.dart';

class FirebaseServiceImpl extends FirebaseService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseServiceImpl(this._auth, this._firestore);

  @override
  Future<UserData> loginOrSignup(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = userCredential.user!;

      List<String> favourites = await _fetchUserFavourites(user.uid);

      return UserData(email: user.email!, id: user.uid, favourites: favourites);
    } catch (error) {
      try {
        UserCredential newUserCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User user = newUserCredential.user!;
        UserData userData =
            UserData(email: user.email!, id: user.uid, favourites: []);

        return userData;
      } catch (signUpError) {
        throw Exception('Some error occurred : ${signUpError.toString()}');
      }
    }
  }

  Future<List<String>> _fetchUserFavourites(String userId) async {
    List<String> favourites = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> favouritesSnapshot =
      await _firestore.collection('users').doc(userId).get();

      if (favouritesSnapshot.exists) {
        Map<String, dynamic> preferencesData = favouritesSnapshot.data()!;
        dynamic userFavourites = preferencesData['favourites'];

        if (userFavourites is List<dynamic>) {
          favourites = userFavourites.whereType<String>().toList();
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user favourites: $error');
      }
    }
    return favourites;
  }

  @override
  Future<void> updateFavourites(List<String> favourites) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user signed in.',
        );
      }
      DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
      await userDocRef.set({'favourites': favourites});
    } catch (error) {
      throw Exception('Failed to update favorites: $error');
    }
  }


  @override
  Future<void> logout() {
   return _auth.signOut();
  }
}
