
import 'package:music_player/domain/repository/user_repository.dart';

class LogoutUseCase {
  final UserRepository _userRepository;

  LogoutUseCase(this._userRepository);

  Future<void> call() {
    return _userRepository.logout();
  }
}