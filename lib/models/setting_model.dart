import 'package:flutter/material.dart';

class SettingModel extends ChangeNotifier {
  // API value
  String get baseURL => 'https://durian-lava.herokuapp.com';

  // End-point for login
  String get endPointLogin => 'api/login';

  // End-point for get user profile
  String get endPointUserProfile => 'api/user/me';

  // Setting Value
  Map<String, dynamic> _value = {};
  Map<String, dynamic> get value => _value;
  set value(Map<String, dynamic> value) {
    _value = value;
    notifyListeners();
  }
}
