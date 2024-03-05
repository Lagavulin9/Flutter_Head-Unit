import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_head_unit/provider/commonAPI.dart';

class PDCModel extends ChangeNotifier {
  Timer? timer;
  final CommonAPI bridge = CommonAPI();
  int _left = 0;
  int _middle = 0;
  int _right = 0;

  PDCModel() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      SonarStruct sonar = bridge.getSonar();
      if (_left != sonar.left ||
          _middle != sonar.middle ||
          _right != sonar.right) {
        _left = sonar.left;
        _middle = sonar.middle;
        _right = sonar.right;
        notifyListeners();
      }
    });
  }

  int get left => _left;
  int get middle => _middle;
  int get right => _right;
}
