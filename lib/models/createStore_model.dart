import 'package:flutter/material.dart';

class CreateStoreModel with ChangeNotifier {
  int _currentIndexPage = 0;

  // State all data.
  String _chosenDistrict;
  String _nameValue = "";
  String _sloganValue = "";
  String _phone1Value = "";
  String _phone2Value = "";
  String _aboutValue = "";

  // Getther
  get getCurrentIndexPage => _currentIndexPage;
  get getChosenDistrict => _chosenDistrict;
  get getNameValue => _nameValue;
  get getSloganValue => _sloganValue;
  get getPhone1Value => _phone1Value;
  get getPhone2Value => _phone2Value;
  get getAboutValue => _aboutValue;

  // Setther
  set setCurrentIndexPage(v) => {_currentIndexPage = v, notifyListeners()};
  set setChosenDistrict(v) => {_chosenDistrict = v, notifyListeners()};
  set setNameValue(v) => {_nameValue = v, notifyListeners()};
  set setSloganValue(v) => {_sloganValue = v, notifyListeners()};
  set setPhone1Value(v) => {_phone1Value = v, notifyListeners()};
  set setPhone2Value(v) => {_phone2Value = v, notifyListeners()};
  set setAboutValue(v) => {_aboutValue = v, notifyListeners()};

  // Clear
  void clear() {
    _currentIndexPage = 0;
    _chosenDistrict = null;
    _nameValue = "";
    _sloganValue = "";
    _phone1Value = "";
    _phone2Value = "";
    _aboutValue = "";
    notifyListeners();
  }
}
