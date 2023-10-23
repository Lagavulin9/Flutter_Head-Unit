import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/pages/car_info.dart';
import 'package:flutter_head_unit/pages/music_player.dart';
import 'package:flutter_head_unit/pages/settings.dart';

class AppController extends ChangeNotifier {
  Widget _currentPage = CarInfo();

  Widget get currentPage => _currentPage;

  void updatePage(Widget page) {
    _currentPage = page;
    notifyListeners();
  }
}
