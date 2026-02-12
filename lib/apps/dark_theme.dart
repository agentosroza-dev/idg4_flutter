import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme(int scaleIndex) {
  final fgColor = Colors.white;
  final bgColor = Colors.blueGrey.shade900;
  return ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      titleSmall: GoogleFonts.carlito(fontSize: 16 + (scaleIndex * 3)),
      titleMedium: GoogleFonts.carlito(fontSize: 20 + (scaleIndex * 3)),
      titleLarge: GoogleFonts.carlito(fontSize: 24 + (scaleIndex * 3)),
      bodyMedium: GoogleFonts.carlito(fontSize: 18 + (scaleIndex * 3)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: CircleBorder(),
      backgroundColor: bgColor,
      foregroundColor: fgColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      centerTitle: true,
      elevation: 8,
    ),
    cardTheme: CardThemeData(color: Colors.grey.shade900, elevation: 1),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: bgColor,
        disabledForegroundColor: fgColor,
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      // backgroundColor: bgColor,
      selectedItemColor: fgColor,
    ),
  );
}
