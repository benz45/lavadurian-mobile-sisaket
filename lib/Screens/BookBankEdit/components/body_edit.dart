import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool _isBranchValue = false;
  bool _isChosenBank = false;
  bool _isBookbankTypeValue = false;
  bool _isAccountName = false;
  bool _isAccountNumber = false;

  int _storeID;
  int bookbankID;

  final branchController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  List<Map<String, dynamic>> bookbanks;
  Map<String, dynamic> bookbank;

  SettingModel settingModel;
  BookBankModel bookBankModel;
  StoreModel storeModel;

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    bookBankModel = context.read<BookBankModel>();
    storeModel = context.read<StoreModel>();

    _storeID = storeModel.getCurrentStore['id'];
    bookbankID = widget.bookbankID;

    final initBookbank = bookBankModel.bookbank.firstWhere((element) => element['id'] == widget.bookbankID, orElse: () => null);

    if (initBookbank != null) {
      _branchValue = initBookbank['bank_branch'];
      _accountName = initBookbank['account_name'];
      _accountNumber = initBookbank['account_number'];
      branchController.text = initBookbank['bank_branch'];
      nameController.text = initBookbank['account_name'];
      numberController.text = initBookbank['account_number'];
    }

    branchController.addListener(() {
      setState(() {
        _branchValue = branchController.text;
      });
    });
    nameController.addListener(() {
      setState(() {
        _accountName = nameController.text;
      });
    });
    numberController.addListener(() {
      setState(() {
        _accountNumber = numberController.text;
      });
    });
  }

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

    var _bank = bookBankModel.bank.keys.firstWhere((element) => bookBankModel.bank[element] == _chosenBank, orElse: () => null);

    var _type = bookBankModel.type.keys.firstWhere((element) => bookBankModel.type[element] == _bookbankTypeValue, orElse: () => null);

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
        Uri.parse('${settingModel.baseURL}/${settingModel.endPoinUpdateBookBank}'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonData['status'] == true) {
          // update state
          bookBankModel.updateBookbank(bookbankId: bookbankID, value: jsonData['data']['bookbank']);
          showFlashBar(context, message: 'แก้ไขข้อมูลเรียบร้อยแล้ว', success: true, duration: 3500);

          _btnController.success();
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        } else {
          showFlashBar(context, message: 'เกิดข้อผิดพลาดระหว่างบันทึกข้อมูล', error: true);
        }
      } else {
        showFlashBar(context, message: 'บันทึกข้อมูลไม่สำเร็จ code: ${response.statusCode}', error: true);
      }
    } catch (e) {
      showFlashBar(context, message: 'เกิดข้อผิดพลาดไม่สามารถอัปเดได้', error: true);
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    bookbank = bookBankModel.bookbank.firstWhere((element) => element['id'] == widget.bookbankID);

    if (_bookbankTypeValue == null) {
      _bookbankTypeValue = bookBankModel.type[bookbank['account_type'].toString()];
    }

    if (_chosenBank == null) {
      _chosenBank = bookBankModel.bank[bookbank['bank'].toString()];
    }

    // Edit Button
    final _submitButton = RoundedLoadingButton(
      child: Text(
        "แก้ไขบัญชี",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      borderRadius: 10,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        _onSubmit();
      },
    );

    return Padding(
      padding: EdgeInsets.all(26.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _isAccountNumber = !_isAccountNumber;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'เลขที่บัญชี',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                          Text(
                            '$_accountNumber',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                        ],
                      ),
                      if (!_isAccountNumber)
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: kTextSecondaryColor,
                        ),
                      if (_isAccountNumber)
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: kTextSecondaryColor,
                        )
                    ],
                  ),
                ),
                if (_isAccountNumber)
                  RoundedInputField(
                    hintText: "เลขที่บัญชี",
                    icon: Icons.credit_card_rounded,
                    onChanged: (v) {
                      _accountNumber = v;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    controller: numberController,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  ),
                Divider(),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isAccountName = !_isAccountName;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ชื่อบัญชี',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                          Text(
                            '$_accountName',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                        ],
                      ),
                      if (!_isAccountName)
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: kTextSecondaryColor,
                        ),
                      if (_isAccountName)
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: kTextSecondaryColor,
                        )
                    ],
                  ),
                ),
                if (_isAccountName)
                  RoundedInputField(
                    hintText: "ชื่อบัญชี",
                    icon: Icons.person_outlined,
                    onChanged: (v) {
                      _accountName = v;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    controller: nameController,
                  ),
                Divider(),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isBranchValue = !_isBranchValue;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สาขา',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                          Text(
                            '$_branchValue',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                        ],
                      ),
                      if (!_isBranchValue)
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: kTextSecondaryColor,
                        ),
                      if (_isBranchValue)
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: kTextSecondaryColor,
                        )
                    ],
                  ),
                ),
                if (_isBranchValue)
                  RoundedInputField(
                    hintText: "สาขา",
                    icon: Icons.home_work_outlined,
                    onChanged: (v) {
                      _branchValue = v;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    controller: branchController,
                    // inputFormatters: limitingTextInput,
                  ),
                Divider(),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isChosenBank = !_isChosenBank;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ธนาคาร',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                          Text(
                            '$_chosenBank',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                        ],
                      ),
                      if (!_isChosenBank)
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: kTextSecondaryColor,
                        ),
                      if (_isChosenBank)
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: kTextSecondaryColor,
                        )
                    ],
                  ),
                ),
                if (_isChosenBank)
                  DropdownButton<String>(
                    value: _chosenBank,
                    isExpanded: true,
                    hint: Text(
                      "เลือกธนาคาร",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
                    ),
                    items: bookBankModel.bank.entries.map((e) {
                      return new DropdownMenuItem<String>(
                        value: e.value,
                        child: new Text(e.value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      _chosenBank = value;
                    },
                  ),
                Divider(),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isBookbankTypeValue = !_isBookbankTypeValue;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ประเภทบัญชี',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                          Text(
                            '$_bookbankTypeValue',
                            style: TextStyle(color: kTextSecondaryColor),
                          ),
                        ],
                      ),
                      if (!_isBookbankTypeValue)
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: kTextSecondaryColor,
                        ),
                      if (_isBookbankTypeValue)
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: kTextSecondaryColor,
                        )
                    ],
                  ),
                ),
                if (_isBookbankTypeValue)
                  DropdownButton<String>(
                    value: _bookbankTypeValue,
                    isExpanded: true,
                    hint: Text(
                      "ประเภทบัญชี",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
                    ),
                    items: bookBankModel.type.entries.map((e) {
                      return new DropdownMenuItem<String>(
                        value: e.value,
                        child: Text(e.value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      _bookbankTypeValue = value;
                    },
                  ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: _submitButton,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
