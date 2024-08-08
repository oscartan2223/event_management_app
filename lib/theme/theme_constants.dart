import 'package:assignment/theme/fonts.dart';
import 'package:flutter/material.dart';

class CustomizedColors {
  static const Color buttonFontColor = Colors.white;
  static const Color backgroundColor = Colors.white;
  static const Color disabledColor = Color.fromARGB(183, 242, 242, 242);
  static const Color fontColor = Colors.black;
  static const Color buttonColor = Color(0xFF27A1FF);
  static const Color linkColor = Color(0xFF27A1FF);
  static const Color selectedColor = Color(0xFF444CB4);
  static const Color unselectedColor = Color.fromARGB(255, 120, 120, 120);
  static const Color warningColor = Color(0xFFFF0000);
}

ThemeData customTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF27A1FF),
  disabledColor: const Color.fromARGB(255, 120, 120, 120),
  focusColor: const Color(0xFF444CB4),
  shadowColor: Colors.black,
  fontFamily: 'Fredoka',
  scaffoldBackgroundColor: const Color.fromARGB(255, 247, 247, 247),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: Colors.black,
    elevation: 18,
    titleTextStyle: titleTextStyle,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    surfaceTintColor: Colors.white,
    color: Colors.white,
  ),
  cardTheme: const CardTheme(
    surfaceTintColor: Colors.white,
    color: Colors.white
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white
  )
);
