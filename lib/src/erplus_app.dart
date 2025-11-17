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
      theme: _corporateLightTheme,
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
// 🎨 B) Modern Kurumsal Light (Microsoft 365)
// ------------------------------------------------------------
final ThemeData _corporateLightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFEFF4FF), // hafif mavi-gri

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1D4ED8),
    secondary: Color(0xFF0EA5E9),
    surface: Color(0xFFF9FAFB),
  ),
  cardColor: const Color(0xFFF9FAFB),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF9FAFB),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF111827)),
    titleTextStyle: TextStyle(
      color: Color(0xFF111827),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF111827)),
    bodySmall: TextStyle(color: Color(0xFF6B7280)),
  ),
  dividerColor: Color(0xFFD1D5DB),
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
