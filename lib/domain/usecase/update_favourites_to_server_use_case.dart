import '../repository/user_repository.dart';
import '../result.dart';

class UpdateFavouritesToServerUseCase {
  final UserRepository _userRepository;

  UpdateFavouritesToServerUseCase(this._userRepository);

  Future<Result<void>> call([List<String>? favourites]) {
    return _userRepository.updateFavouritesToServer(favourites);
  }
}
