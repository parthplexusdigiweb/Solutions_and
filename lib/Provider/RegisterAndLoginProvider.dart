import 'package:flutter/material.dart';

class LoginRegisterProvider with ChangeNotifier{
  bool isVisible = false;

  void toggleVisibility() {
      isVisible = !isVisible;
      notifyListeners();
  }

}