import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/domain/usecase/update_favourites_to_db_use_case.dart';
import 'package:music_player/domain/usecase/update_favourites_to_server_use_case.dart';
import '../../../domain/usecase/get_user_favourites_use_case.dart';
import '../../../domain/usecase/logout_use_case.dart';

class HomeController extends StateNotifier<List<String>> {
  final UpdateFavouritesToServerUseCase _updateFavouritesToServerUseCase;
  final UpdateFavouritesToDbUseCase _updateFavouritesToDbUseCase;
  final GetUserFavouritesUseCase _getUserFavouritesUseCase;
  final LogoutUseCase _logoutUseCase;

  HomeController(
      this._updateFavouritesToServerUseCase,
      this._updateFavouritesToDbUseCase,
      this._getUserFavouritesUseCase,
      this._logoutUseCase)
      : super([]);

  void updateFavourites(List<String> favourites) async {
    state = favourites;
    try {
      await _updateFavouritesToDbUseCase(favourites);
      await _updateFavouritesToServerUseCase(favourites);
    } catch (error) {
      //handle error
    }
  }

  Future<void> getUserFavourites() async {
    try {
      final favourites = await _getUserFavouritesUseCase();
      state = favourites;
    } catch (error) {
      //handle error
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
  }
}
