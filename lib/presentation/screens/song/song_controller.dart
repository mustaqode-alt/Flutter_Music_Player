

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/domain/usecase/update_favourites_to_db_use_case.dart';
import 'package:music_player/domain/usecase/update_favourites_to_server_use_case.dart';

class SongController extends StateNotifier<List<String>> {
  final UpdateFavouritesToServerUseCase _updateFavouritesToServerUseCase;
  final UpdateFavouritesToDbUseCase _updateFavouritesToDbUseCase;

  SongController(
      this._updateFavouritesToServerUseCase,
      this._updateFavouritesToDbUseCase,)
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

}
