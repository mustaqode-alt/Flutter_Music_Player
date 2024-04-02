import 'package:flutter/material.dart';

import '../palette.dart';

class CustomThemes {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Palette.primaryLight,
      secondary: Palette.secondaryLight,
      background: Palette.backgroundLight,
      onPrimary: Palette.textLight,
      onSecondary: Palette.textLight,
      onBackground: Palette.textLight,
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Palette.primaryDark,
      secondary: Palette.secondaryDark,
      background: Palette.backgroundDark,
      onPrimary: Palette.textDark,
      onSecondary: Palette.textDark,
      onBackground: Palette.textDark,
    ),
  );
}
