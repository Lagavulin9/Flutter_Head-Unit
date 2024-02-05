import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/music/music_app.dart';

class AppController extends ChangeNotifier {
  Widget _currentPage = const MusicApp();

  Widget get currentPage => _currentPage;

  void updatePage(Widget page) {
    _currentPage = page;
    notifyListeners();
  }
}
