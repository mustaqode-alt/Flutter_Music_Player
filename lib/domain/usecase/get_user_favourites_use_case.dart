
import '../repository/user_repository.dart';

class GetUserFavouritesUseCase {
  final UserRepository _userRepository;

  GetUserFavouritesUseCase(this._userRepository);

  Future<List<String>> call() {
    return _userRepository.getUserFavourites();
  }
}