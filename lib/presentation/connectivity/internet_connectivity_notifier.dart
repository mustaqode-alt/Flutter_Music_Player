import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:music_player/domain/usecase/update_favourites_to_server_use_case.dart';
import 'package:riverpod/riverpod.dart';

class InternetConnectivityNotifier extends StateNotifier<bool> {
  final UpdateFavouritesToServerUseCase _updateFavouritesToServerUseCase;

  bool wasOffline = false;

  InternetConnectivityNotifier(this._updateFavouritesToServerUseCase)
      : super(false) {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        state = false;
        wasOffline = true;
      } else if (wasOffline && result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        state = true;
        wasOffline = false;
        await updateFavouritesToServer();
      }
    });
  }

  /// Syncs favs to server whenever internet connectivity changes from offline to online
  Future<void> updateFavouritesToServer() async {
    _updateFavouritesToServerUseCase();
  }
}
