import 'package:flutter/material.dart';

class SettingModel extends ChangeNotifier {
  Map<String, dynamic> _value = {};

  Map<String, dynamic> get value => _value;

  set value(Map<String, dynamic> value) {
    _value = value;
    notifyListeners();
  }
}
