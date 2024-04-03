import 'package:music_player/data/datasource/local/db_manager.dart';
import 'package:music_player/data/datasource/remote/firebase_service.dart';
import 'package:music_player/domain/entity/user_data.dart';
import 'package:music_player/domain/repository/user_repository.dart';
import 'package:music_player/domain/result.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseService _fbService;
  final DbManager _dbManager;

  UserRepositoryImpl(this._fbService, this._dbManager);

  @override
  Future<List<String>> getUserFavourites() {
    return _dbManager.getFavourites();
  }

  @override
  Future<Result<UserData>> loginOrSignup(String email, String password) async {
    try {
      UserData userData = await _fbService.loginOrSignup(email, password);
      await _dbManager.saveFavourites(userData.favourites);
      return Result.success(userData);
    } catch (error) {
      return Result.error(error.toString());
    }
  }

  @override
  Future<void> updateFavouritesToDb(List<String> favourites) {
    return _dbManager.saveFavourites(favourites);
  }

  @override
  Future<Result<void>> updateFavouritesToServer(List<String>? favourites) async {
    try {
      favourites = favourites ?? await _dbManager.getFavourites();
      var updateFav = await _fbService.updateFavourites(favourites);
      return Result.success(updateFav);
    } catch (error) {
      return Result.error(error.toString());
    }
  }

  @override
  Future<void> logout()  {
   return _fbService.logout();
  }

}
