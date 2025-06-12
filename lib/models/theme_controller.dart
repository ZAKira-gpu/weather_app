// lib/theme_controller.dart

import 'package:flutter/material.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeModeNotifier =
  ValueNotifier(ThemeMode.system);

  static void toggleTheme() {
    final current = themeModeNotifier.value;
    themeModeNotifier.value =
    current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
