import 'package:flutter/material.dart';

class UserSession with ChangeNotifier {
  bool _isLoggedIn = false;
  String _emailId = '';
  String _loginToken = '';

  bool get isLoggedIn => _isLoggedIn;
  String get emailId => _emailId;
  String get loginToken => _loginToken;

  void login(String email, String token) {
    _isLoggedIn = true;
    _emailId = email;
    _loginToken = token;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _emailId = '';
    _loginToken = '';
    notifyListeners();
  }
}
