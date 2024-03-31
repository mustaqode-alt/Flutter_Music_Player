import 'package:music_player/domain/entity/user_data.dart';
import 'package:music_player/domain/repository/user_repository.dart';
import 'package:music_player/domain/result.dart';

class LoginOrSignupUseCase {
  final UserRepository _userRepository;

  LoginOrSignupUseCase(this._userRepository);

  Future<Result<UserData>> call(String email, String password) {
    return _userRepository.loginOrSignup(email, password);
  }

}