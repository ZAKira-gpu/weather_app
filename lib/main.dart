// lib/main.dart

import 'package:flutter/material.dart';
import 'package:weather_app/models/theme_controller.dart';
import 'screens/home_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: '3D Weather App',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF5ea092),
            scaffoldBackgroundColor: Colors.transparent,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5ea092),
              primary: const Color(0xFF5ea092),
              secondary: const Color(0xFF417f71),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            textTheme: const TextTheme(
              headlineMedium: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3b6c60),
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Color(0xFF3b6c60),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5ea092),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 24),
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.transparent,
            primaryColor: const Color(0xFF5ea092),
            fontFamily: 'Roboto',
            textTheme: const TextTheme(
              headlineMedium: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
