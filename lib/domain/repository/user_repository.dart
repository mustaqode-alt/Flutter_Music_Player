

import 'package:music_player/domain/entity/user_data.dart';

import '../result.dart';

abstract class UserRepository {

  Future<Result<UserData>> loginOrSignup(String email, String password);

  Future<void> updateFavouritesToDb(List<String> favourites);

  Future<Result<void>> updateFavouritesToServer(List<String> favourites);

  Future<List<String>> getUserFavourites();

}