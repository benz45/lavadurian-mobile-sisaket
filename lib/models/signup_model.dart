import 'package:flutter/material.dart';

class SignupModel with ChangeNotifier {
  String citizenId;

  String get citizenIdValue => citizenId;

  set setCitizenId(value) {
    citizenId = value;
    notifyListeners();
  }
}
