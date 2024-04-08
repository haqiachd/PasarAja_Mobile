import 'package:flutter/material.dart';

class WelcomeProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int c) {
    _currentIndex = c;
    notifyListeners();
  }
}
