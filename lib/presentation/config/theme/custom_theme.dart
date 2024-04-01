import 'package:flutter/material.dart';
import 'package:music_player/presentation/config/palette.dart';

class CustomThemes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Palette.primaryLight,
    secondaryHeaderColor: Palette.secondaryLight,
    scaffoldBackgroundColor: Palette.backgroundLight,
    textTheme: const TextTheme().apply(bodyColor: Palette.textLight, displayColor: Palette.textLight),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Palette.primaryDark,
    secondaryHeaderColor: Palette.secondaryDark,
    scaffoldBackgroundColor: Palette.backgroundDark,
    textTheme: const TextTheme().apply(bodyColor: Palette.textDark, displayColor: Palette.textDark),
  );

}

