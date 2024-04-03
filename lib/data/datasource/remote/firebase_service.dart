

import 'package:music_player/domain/entity/user_data.dart';

import '../../../domain/result.dart';

abstract class FirebaseService {

  Future<UserData> loginOrSignup(String email, String password);

  Future<void> updateFavourites(List<String> favourites);

  Future<void> logout();

}