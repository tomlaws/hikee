import 'package:flutter/cupertino.dart';

class PageViewState  extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage =>_currentPage;
  PageViewState();

  updatePage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}