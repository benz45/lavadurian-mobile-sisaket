import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  Map<String, dynamic> _value = {};

  Map<String, dynamic> get value => _value;

  // Clear State
  void clear() => {_value.clear(), notifyListeners()};

  set value(Map<String, dynamic> value) {
    _value = value;
    notifyListeners();
  }
}
