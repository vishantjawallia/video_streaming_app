import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      labelLarge: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    cardTheme: CardTheme(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    cardTheme: CardTheme(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
    ),
  );
}



enum AppThemeColor {
  blue,
  red,
  green,
  orange,
  purple,
}

final Map<AppThemeColor, Color> appThemeColors = {
  AppThemeColor.blue: Colors.blue,
  AppThemeColor.red: Colors.red,
  AppThemeColor.green: Colors.green,
  AppThemeColor.orange: Colors.orange,
  AppThemeColor.purple: Colors.purple,
};

ThemeData getThemeData(AppThemeColor color) {
  final baseColor = appThemeColors[color]!;
  return ThemeData(
    primarySwatch: MaterialColor(
      baseColor.value,
      <int, Color>{
        50: baseColor.withOpacity(.1),
        100: baseColor.withOpacity(.2),
        200: baseColor.withOpacity(.3),
        300: baseColor.withOpacity(.4),
        400: baseColor.withOpacity(.5),
        500: baseColor,
        600: baseColor.withOpacity(.7),
        700: baseColor.withOpacity(.8),
        800: baseColor.withOpacity(.9),
        900: baseColor,
      },
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
      primary: baseColor,
      secondary: baseColor,
    ),
    // ...other theme properties as needed
  );
}