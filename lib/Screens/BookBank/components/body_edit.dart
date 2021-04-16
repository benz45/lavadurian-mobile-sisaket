import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BodyEdit extends StatefulWidget {
  final bookbankID;
  const BodyEdit({Key key, @required this.bookbankID}) : super(key: key);
  @override
  _BodyEditState createState() => _BodyEditState();
}

class _BodyEditState extends State<BodyEdit> {
  String _chosenBank;
  String _branchValue;
  String _bookbankTypeValue;
  String _accountName;
  String _accountNumber;
  int _storeID;

  TextEditingController branchController;
  TextEditingController nameController;
  TextEditingController numberController;

  List<Map<String, dynamic>> bookbanks;
  Map<String, dynamic> bookbank;

  SettingModel settingModel;
  BookBankModel bookBankModel;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<void> _onSubmit() async {
    // validate data
    if (_chosenBank == null) {
      showSnackBar(context, 'กรุณาเลือกธนาคาร');
      _btnController.reset();
      return false;
    }
    if (_bookbankTypeValue == null) {
      showSnackBar(context, 'กรุณาเลือกประเภทบัญชี');
      _btnController.reset();
      return false;
    }
    if (_branchValue == null || _branchValue == "") {
      showSnackBar(context, 'กรุณากรอกสาขา');
      _btnController.reset();
      return false;
    }
    if (_accountName == null || _accountName == "") {
      showSnackBar(context, 'กรุณากรอกชื่อบัญชี');
      _btnController.reset();
      return false;
    }
    if (_accountNumber == null || _accountNumber == "") {
      showSnackBar(context, 'กรุณากรอกหมายเลขบัญชี');
      _btnController.reset();
      return false;
    }

    var _bank = bookBankModel.bank.keys.firstWhere(
        (element) => bookBankModel.bank[element] == _chosenBank,
        orElse: () => null);

    var _type = bookBankModel.type.keys.firstWhere(
        (element) => bookBankModel.type[element] == _bookbankTypeValue,
        orElse: () => null);

    // get current user token
    String token = settingModel.value['token'];
    Map<String, dynamic> data = {
      'id': widget.bookbankID.toString(),
      'store': _storeID.toString(),
      'bank': _bank.toString(),
      'bank_branch': _branchValue,
      'account_type': _type.toString(),
      'account_name': _accountName,
      'account_number': _accountNumber,
    };

    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPoinUpdateBookBank}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        int index = bookBankModel.bookbank
            .indexWhere((element) => element['id'] == widget.bookbankID);

        // update state
        bookBankModel.bookbank[index] = jsonData['data']['bookbank'];

        _btnController.success();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OperationScreen()));
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      _btnController.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    bookBankModel = context.read<BookBankModel>();
  }

  @override
  Widget build(BuildContext context) {
    bookbank = bookBankModel.bookbank
        .firstWhere((element) => element['id'] == widget.bookbankID);

    if (_bookbankTypeValue == null) {
      _bookbankTypeValue =
          bookBankModel.type[bookbank['account_type'].toString()];
    }

    if (_chosenBank == null) {
      _chosenBank = bookBankModel.bank[bookbank['bank'].toString()];
    }

    _branchValue = bookbank['bank_branch'];
    _accountName = bookbank['account_name'];
    _accountNumber = bookbank['account_number'];
    _storeID = bookbank['store'];

    branchController = TextEditingController(text: _branchValue);
    nameController = TextEditingController(text: _accountName);
    numberController = TextEditingController(text: _accountNumber);

    // Edit Button
    final _submitButton = RoundedLoadingButton(
      child: Text(
        "แก้ไขบัญชี",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        _onSubmit();
      },
    );

    return Padding(
      padding: EdgeInsets.all(26.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropdownButton<String>(
              value: _chosenBank,
              isExpanded: true,
              hint: Text(
                "เลือกธนาคาร",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
              ),
              items: <String>[
                'ธนาคารกรุงเทพ',
                'ธนาคารกสิกรไทย',
                'ธนาคารกรุงไทย',
                'ธนาคารทหารไทย',
                'ธนาคารไทยพาณิชย์',
                'ธนาคารกรุงศรีอยุธยา',
                'ธนาคารออมสิน',
                'ธนาคารเพื่อการเกษตรและสหกรณ์การเกษตร'
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenBank = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropdownButton<String>(
              value: _bookbankTypeValue,
              isExpanded: true,
              hint: Text(
                "ประเภทบัญชี",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
              ),
              items: <String>[
                'กระแสรายวัน',
                'ออมทรัพย์',
                'เงินฝากประจำ',
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _bookbankTypeValue = value;
                });
              },
            ),
          ),
          RoundedInputField(
            hintText: "สาขา",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _branchValue = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: branchController,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "ชื่อบัญชี",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _accountName = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: nameController,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เลขที่บัญชี",
            icon: Icons.add_circle_outline,
            onChanged: (v) {
              _accountNumber = v;
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: numberController,
            // inputFormatters: limitingTextInput,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: _submitButton,
          ),
        ],
      ),
    );
  }
}
