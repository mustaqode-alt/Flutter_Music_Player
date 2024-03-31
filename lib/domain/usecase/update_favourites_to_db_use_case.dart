
import '../repository/user_repository.dart';

class UpdateFavouritesToDbUseCase {
  final UserRepository _userRepository;

  UpdateFavouritesToDbUseCase(this._userRepository);

  Future<void> call(List<String> favourites) {
    return _userRepository.updateFavouritesToDb(favourites);
  }
}