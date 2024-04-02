import 'package:fluttertoast/fluttertoast.dart';

import '../config/palette.dart';

void showToast(String message, [Toast? toast = Toast.LENGTH_SHORT]) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Palette.primaryLight,
      textColor: Palette.textLight,
      toastLength: toast);
}
