import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/common/welcome.dart';

class AppController extends ChangeNotifier {
  Widget _currentPage = const WelcomePage();

  Widget get currentPage => _currentPage;

  void updatePage(Widget page) {
    _currentPage = page;
    notifyListeners();
  }
}
