import 'package:fluttertoast/fluttertoast.dart';

import '../config/palette.dart';

void showToast(String message, [Toast? toast = Toast.LENGTH_SHORT]) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Palette.primaryLight,
      textColor: Palette.textLight,
      toastLength: toast);
}

bool isEmailValid(String email) {
  // Regular expression for basic email validation
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return regex.hasMatch(email);
}

