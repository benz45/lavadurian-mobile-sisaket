import 'package:flutter/material.dart';

class CreateProductModel with ChangeNotifier {
  int _currentIndexPage = 0;

  // State all data.
  int storeID;
  String _chosenGrade;
  String _chosenGene;
  String _chosenStatus;
  String _productValue;
  String _productPrice;
  String _productWeight;
  String _productDetail;

  // Getther
  int get getCurrentIndexPage => _currentIndexPage;
  String get getChosenGrade => _chosenGrade;
  String get getChosenGene => _chosenGene;
  String get getChosenStatus => _chosenStatus;
  String get getProductValue => _productValue;
  String get getProductPrice => _productPrice;
  String get getProductWeight => _productWeight;
  String get getProductDetail => _productDetail;

  // Setther
  set setCurrentIndexPage(v) => {_currentIndexPage = v, notifyListeners()};
  set setChosenGrade(v) => {_chosenGrade = v, notifyListeners()};
  set setChosenGene(v) => {_chosenGene = v, notifyListeners()};
  set setChosenStatus(v) => {_chosenStatus = v, notifyListeners()};
  set setProductValue(v) => {_productValue = v, notifyListeners()};
  set setProductPrice(v) => {_productPrice = v, notifyListeners()};
  set setProductWeight(v) => {_productWeight = v, notifyListeners()};
  set setProductDetail(v) => {_productDetail = v, notifyListeners()};

  // Clear
  void clear() {
    _currentIndexPage = 0;
    storeID = null;
    _chosenGrade = null;
    _chosenGene = null;
    _chosenStatus = null;
    _productValue = null;
    _productPrice = null;
    _productWeight = null;
    _productDetail = null;
    notifyListeners();
  }
}
