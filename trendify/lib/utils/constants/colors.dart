import 'package:flutter/material.dart';

class TColors {
  TColors._();

  //App Basic Colors
  static const Color primary = Color(0xFFE94B4B); // Red
  static const Color secondary = Color(0xFF23395D); // Navy Blue
  static const Color accent = Color(0xFF7EC8E3); // Light Blue

  //gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [Color(0xffff9a9e), Color(0xfffad0c4), Color(0xfffad0c4)],
  );

  //Text Colors
  static const Color textprimary = Color(0xFF23395D); // Navy Blue
  static const Color textsecondary = Color(0xFF7EC8E3); // Light Blue
  static const Color textWhite = Colors.white;

  //Background Colors
  static const Color light = Color(0xFFF6F8FA); // Soft Gray
  static const Color dark = Color(0xFF23395D); // Navy Blue
  static const Color primaryBackground = Color(0xFFFFFFFF); // White

  //Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color darkContainer = Colors.white;

  //Button Colors
  static const Color buttonPrimary = Color(0xFFE94B4B); // Red
  static const Color buttonSecondary = Color(0xFF23395D); // Navy Blue
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  //Border Colors
  static const Color borderPrimary = Color(0xFFD9D9DD);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  //error and validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF4C784); // Beige
  static const Color info = Color(0xFF1976D2);

  //neutral Colors
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
