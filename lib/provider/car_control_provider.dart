import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/commonAPI.dart';

class ControlModel extends ChangeNotifier {
  Timer? timer;
  final CommonAPI bridge = CommonAPI();
  late String _gear;

  String get gear => _gear;

  void setGear(String gear) {
    bridge.setGear(gear);
  }

  ControlModel() {
    _gear = bridge.getGear();
    timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      String new_gear = bridge.getGear();
      if (_gear != new_gear) {
        _gear = new_gear;
        notifyListeners();
      }
    });
  }
}
