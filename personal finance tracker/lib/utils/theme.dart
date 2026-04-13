import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2f7f33),
    brightness: Brightness.light,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF000000),
    surfaceContainerHighest: const Color(0xFFFFFFFF),
  ),
  primaryColor: const Color(0xFF2f7f33),
  scaffoldBackgroundColor: const Color(0xFFf6f8f6),
  fontFamily: GoogleFonts.tajawal().fontFamily,
  cardTheme: CardThemeData(
    color: Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.tajawal(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
  ),
  textTheme: GoogleFonts.tajawalTextTheme(),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4CAF50),
    brightness: Brightness.dark,
    surface: const Color(0xFF1E1E1E),
    onSurface: const Color(0xFFFFFFFF),
    surfaceContainerHighest: const Color(0xFF1E1E1E),
  ),
  primaryColor: const Color(0xFF4CAF50),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  fontFamily: GoogleFonts.tajawal().fontFamily,
  brightness: Brightness.dark,
  cardTheme: CardThemeData(
    color: Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.tajawal(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
    ),
  ),
  textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
);
