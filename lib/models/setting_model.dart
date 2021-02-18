import 'package:flutter/material.dart';

class SettingModel extends ChangeNotifier {
  // API value
  String get baseURL => 'https://durian-lava.herokuapp.com';

  // End-point for Login
  String get endPointLogin => 'api/login';

  // End-point for get User Profile
  String get endPointUserProfile => 'api/user/me';

  // End-point for Reset Password
  String get endPointResetPassword => 'dj-rest-auth/password/reset/';

  // Setting Value
  Map<String, dynamic> _value = {};
  Map<String, dynamic> get value => _value;
  set value(Map<String, dynamic> value) {
    _value = value;
    notifyListeners();
  }
}
