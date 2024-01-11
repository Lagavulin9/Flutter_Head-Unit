import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  Color get iconColor => _mode == ThemeMode.light ? Colors.black : Colors.white;
  Color get textColor => _mode == ThemeMode.light ? Colors.black : Colors.white;
  Color get sliderColor =>
      _mode == ThemeMode.light ? Colors.black : Colors.white;

  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
