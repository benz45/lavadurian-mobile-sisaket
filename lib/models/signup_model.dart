import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

SignupModel signupModelFromJson(String str) =>
    SignupModel.fromJson(json.decode(str));

String signupModelToJson(SignupModel data) => json.encode(data.toJson());

class SignupModel with ChangeNotifier, DiagnosticableTreeMixin {
  String password;
  String email;
  String firstName;
  String lastName;
  String citizenid;
  String tradertype;
  String tradername;
  String phone;

  // Trader of Type
  Map tTrader;

  SignupModel({
    String password = '',
    String email = '',
    String firstName = '',
    String lastName = '',
    String citizenid = '',
    String tradertype = '',
    String tradername = '',
    String phone = '',
    Map tTrader,
  })  : this.password = password,
        this.email = email,
        this.firstName = firstName,
        this.lastName = lastName,
        this.citizenid = citizenid,
        this.tradertype = 'พ่อค้าคนกลาง',
        this.tradername = tradername,
        this.phone = phone,
        this.tTrader = {'0': "พ่อค้าคนกลาง", '1': "เจ้าของสวน"};

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        password: json["password"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        citizenid: json["citizenid"],
        tradertype: json["tradertype"],
        tradername: json["tradername"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "citizenid": citizenid,
        "tradertype": tradertype,
        "tradername": tradername,
        "phone": phone,
      };

  String get getEmail => email;
  String get getPassword => password;
  String get getFirstName => firstName;
  String get getLastName => lastName;
  String get getCitizenid => citizenid;
  String get getTradertype => tradertype;
  String get getTradername => tradername;
  String get getPhoneNumber => phone;

  // Void notifyListeners
  void nL() => notifyListeners();

  set setEmail(String val) => {email = val, nL()};
  set setPassword(String val) => {password = val, nL()};
  set setFirstName(String val) => {firstName = val, nL()};
  set setLastName(String val) => {lastName = val, nL()};
  set setCitizenid(String val) => {citizenid = val, nL()};
  set setTradername(String val) => {tradername = val, nL()};
  set setPhoneNumber(String val) => {phone = val, nL()};
  set setTradertype(String val) => {tradertype = tTrader[val], nL()};

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('email', email));
    properties.add(StringProperty('password', password));
    properties.add(StringProperty('first_name', firstName));
    properties.add(StringProperty('last_name', lastName));
    properties.add(StringProperty('citizenid', citizenid));
    properties.add(StringProperty('tradertype', tradertype));
    properties.add(StringProperty('tradername', tradername));
    properties.add(StringProperty('phone', phone));
  }
}

ResponseSignupModel responseSignupModelFromJson(String str) =>
    ResponseSignupModel.fromJson(json.decode(str));

String responseSignupModelToJson(ResponseSignupModel data) =>
    json.encode(data.toJson());

class ResponseSignupModel {
  ResponseSignupModel({
    this.status,
    this.message,
    this.email,
    this.username,
  });

  bool status;
  String message;
  String email;
  String username;

  factory ResponseSignupModel.fromJson(Map<String, dynamic> json) =>
      ResponseSignupModel(
        status: json["status"],
        message: json["message"],
        email: json["email"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "email": email,
        "username": username,
      };
}
