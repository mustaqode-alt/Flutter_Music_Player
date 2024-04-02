

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/domain/entity/user_data.dart';
import 'package:music_player/domain/result.dart';
import 'package:music_player/domain/usecase/login_or_signup_use_case.dart';

class LoginController extends StateNotifier<Result<UserData>> {

  final LoginOrSignupUseCase _loginOrSignupUseCase;

  LoginController(this._loginOrSignupUseCase) : super(Result.initial());

  void loginOrSignup(String email, String password) async {
    state = Result.loading();
    try {
      final response = await _loginOrSignupUseCase(email, password);
      if(response.data != null) {
        state = Result.success(response.data);
      } else {
        state = Result.error(response.error);
      }
    }catch(error) {
      state = Result.error(error.toString());
    }
  }


}