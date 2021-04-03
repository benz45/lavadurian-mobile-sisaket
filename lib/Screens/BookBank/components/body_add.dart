import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Body extends StatefulWidget {
  final bookbankID;
  const Body({Key key, @required this.bookbankID}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _chosenBank;
  String _branchValue;
  String _bookbankTypeValue;
  String _accountName;
  String _accountNumber;

  SettingModel settingModel;

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
    if (_branchValue == null) {
      showSnackBar(context, 'กรุณากรอกสาขา');
      _btnController.reset();
      return false;
    }
    if (_accountName == null) {
      showSnackBar(context, 'กรุณากรอกชื่อบัญชี');
      _btnController.reset();
      return false;
    }
    if (_accountNumber == null) {
      showSnackBar(context, 'กรุณากรอกหมายเลขบัญชี');
      _btnController.reset();
      return false;
    }

    // get current user token
    String token = settingModel.value['token'];

    _btnController.reset();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Edit Button
    final _submitButton = RoundedLoadingButton(
      child: Text(
        "เพิ่มบัญชี",
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

    return SingleChildScrollView(
      child: Padding(
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
              // inputFormatters: limitingTextInput,
            ),
            RoundedInputField(
              hintText: "ชื่อบัญชี",
              icon: Icons.add_circle_outline,
              onChanged: (v) => _accountName = v,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
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
              // inputFormatters: limitingTextInput,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: _submitButton,
            ),
          ],
        ),
      ),
    );
  }
}
