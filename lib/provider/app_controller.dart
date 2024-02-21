import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/common/welcome.dart';
import 'package:flutter_head_unit/pdc/sensor_view.dart';

class AppController extends ChangeNotifier {
  Widget _currentPage = const SensorView();

  Widget get currentPage => _currentPage;

  void updatePage(Widget page) {
    _currentPage = page;
    notifyListeners();
  }
}
