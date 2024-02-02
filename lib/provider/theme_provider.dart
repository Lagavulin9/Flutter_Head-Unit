import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/commonAPI.dart';

class ThemeModel extends ChangeNotifier {
  final CommonAPI bridge = CommonAPI();
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  Color get iconColor => _mode == ThemeMode.light ? Colors.black : Colors.white;
  Color get textColor => _mode == ThemeMode.light ? Colors.black : Colors.white;
  Color get sliderColor =>
      _mode == ThemeMode.light ? Colors.black : Colors.white;
  Color get backgroundColor => _mode == ThemeMode.light
      ? const Color.fromRGBO(245, 245, 245, 1)
      : const Color.fromRGBO(60, 60, 60, 1);

  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    bridge.setLightMode(_mode == ThemeMode.light);
    notifyListeners();
  }

  void setLightMode() {
    _mode = ThemeMode.light;
    bridge.setLightMode(true);
    notifyListeners();
  }

  void setDarkMode() {
    _mode = ThemeMode.dark;
    bridge.setLightMode(false);
    notifyListeners();
  }
}
