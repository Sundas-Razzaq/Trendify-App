import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/colors.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static final lightAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: TColors.primaryBackground,
    surfaceTintColor: TColors.primaryBackground,
    iconTheme: IconThemeData(color: TColors.secondary, size: 24),
    actionsIconTheme: IconThemeData(color: TColors.secondary, size: 24),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: TColors.secondary,
    ),
  );

  static final darkAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: TColors.dark,
    surfaceTintColor: TColors.dark,
    iconTheme: IconThemeData(color: TColors.accent, size: 24),
    actionsIconTheme: IconThemeData(color: TColors.accent, size: 24),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: TColors.accent,
    ),
  );
}
