import 'package:flutter/material.dart';

class SettingModel extends ChangeNotifier {
  // API value
  // String get baseURL => 'https://durian-lava.herokuapp.com';
  String get baseURL => 'http://127.0.0.1:8000';

  // End-point for Login
  String get endPointLogin => 'api/login';

  // End-point for Login
  String get endPointRegis => 'api/regis';

  // End-point for get User Profile
  String get endPointUserProfile => 'api/user/me';

  // End-point for Reset Password
  String get endPointResetPassword => 'dj-rest-auth/password/reset/';

  // End-point for Check Exist Citizen ID
  String get endPointCheckCitizenId => 'api/check/id';

  // End-point for Check Exist Email
  String get endPointCheckEmail => 'api/check/email';

  // End-point for get Store Profile of Current Trader
  String get endPointGetStoreProfile => 'api/store/get';

  // End-point for upload product image
  String get endPointUploadProductImage => 'api/product-img/add';

  // End-point for add new product
  String get endPointAddProduct => 'api/product/add';

  // End-point for edit product
  String get endPointEditProduct => 'api/product/edit';

  // End-point for delete product
  String get endPointDeleteProduct => 'api/product/delete';

  // End-point for regis new store
  String get endPointAddStore => 'api/store/add';

  // End-point for edit store
  String get endPoinEditStore => 'api/store/edit';

  // End-point for delete store
  String get endPoinDeleteStore => 'api/store/delete';

  // End-point for edit bookbank
  String get endPoinUpdateBookBank => 'api/bookbank/edit';

  // End-point for add new bookbank
  String get endPoinAddBookBank => 'api/bookbank/add';

  // End-point for delete new bookbank
  String get endPoinDeleteBookBank => 'api/bookbank/delete';

  // Setting Value
  Map<String, dynamic> _value = {};
  Map<String, dynamic> get value => _value;
  set value(Map<String, dynamic> value) {
    _value = value;
    notifyListeners();
  }
}
