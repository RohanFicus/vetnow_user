import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  void setSystem() {
    setMode(ThemeMode.system);
  }

  void setLight() {
    setMode(ThemeMode.light);
  }

  void setDark() {
    setMode(ThemeMode.dark);
  }

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void toggle() {
    setMode(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
