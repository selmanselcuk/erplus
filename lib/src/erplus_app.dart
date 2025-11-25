import 'package:flutter/material.dart';
import 'shell/erplus_shell.dart';

class ERPlusApp extends StatelessWidget {
  const ERPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERPlus',
      debugShowCheckedModeBanner: false,

      // 🎨 BURADAN TEMAYI SEÇİYORSUN:
      //theme: _appleLightTheme,
      theme: _sfProTheme,
      //theme: _materialLightTheme,
      home: const ERPlusShell(),
    );
  }
}

// ------------------------------------------------------------
// 🎨 A) Apple Tarzı Ultra Soft Light Theme
// ------------------------------------------------------------
final ThemeData _appleLightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF5F6FA),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2563EB),
    secondary: Color(0xFF38BDF8),
    surface: Colors.white,
  ),
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF0F172A)),
    titleTextStyle: TextStyle(
      color: Color(0xFF0F172A),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF1F2933)),
    bodySmall: TextStyle(color: Color(0xFF6B7280)),
  ),
  dividerColor: Color(0xFFE2E8F0),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
);

// ------------------------------------------------------------
// 🎨 B) SF Pro Display Premium Theme (Apple Style)
// ------------------------------------------------------------
final ThemeData _sfProTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF5F7FA),
  fontFamily: '.SF Pro Display',
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF007AFF),
    secondary: Color(0xFF5AC8FA),
    surface: Colors.white,
  ),
  cardColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF1C1C1E)),
    titleTextStyle: TextStyle(
      color: Color(0xFF1C1C1E),
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: '.SF Pro Display',
      letterSpacing: -0.5,
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 34,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1C1C1E),
      letterSpacing: -1.0,
    ),
    displayMedium: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1C1C1E),
      letterSpacing: -0.8,
    ),
    displaySmall: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1C1C1E),
      letterSpacing: -0.6,
    ),
    headlineMedium: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1C1C1E),
      letterSpacing: -0.4,
    ),
    bodyLarge: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: Color(0xFF1C1C1E),
      letterSpacing: -0.4,
    ),
    bodyMedium: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFF1C1C1E),
      letterSpacing: -0.3,
    ),
    bodySmall: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF8E8E93),
      letterSpacing: -0.1,
    ),
    labelLarge: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1C1C1E),
      letterSpacing: -0.3,
    ),
    labelMedium: TextStyle(
      fontFamily: '.SF Pro Display',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1C1C1E),
      letterSpacing: -0.1,
    ),
  ),
  dividerColor: const Color(0xFFE5E5EA),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
);

// ------------------------------------------------------------
// 🎨 C) Google Material 3 Light (Android Hissi)
// ------------------------------------------------------------
final ThemeData _materialLightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFFDF2FF), // çok hafif lila
  cardColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF111827)),
    bodySmall: TextStyle(color: Color(0xFF4B5563)),
  ),
  appBarTheme: const AppBarTheme(elevation: 0),
  dividerColor: Color(0xFFE5E7EB),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
);
