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

class BodyCreate extends StatefulWidget {
  @override
  _BodyCreateState createState() => _BodyCreateState();
}

class _BodyCreateState extends State<BodyCreate> {
  String _chosenDistrict;
  String _nameValue;
  String _sloganValue;
  String _phone1Value;
  String _phone2Value = "";
  String _aboutValue;

  StoreModel storeModel;
  SettingModel settingModel;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<void> _onSubmit() async {
    String district;

    if (_chosenDistrict == null) {
      showSnackBar(context, 'กรุณาเลือกเขตอำเภอ');
      _btnController.reset();
      return false;
    } else {
      district = storeModel.district.keys.firstWhere(
          (element) => storeModel.district[element] == _chosenDistrict);
    }

    if (_nameValue == null || _nameValue == "") {
      showSnackBar(context, 'กรุณากรอกชื่อร้านค้า');
      _btnController.reset();
      return false;
    }
    if (_sloganValue == null || _sloganValue == "") {
      showSnackBar(context, 'กรุณากรอกข้อมูลสโลแกนร้านค้า');
      _btnController.reset();
      return false;
    }
    if (_phone1Value == null || _phone1Value == "") {
      showSnackBar(context, 'กรุณากรอกหมายเลขติดต่อ');
      _btnController.reset();
      return false;
    }
    if (_aboutValue == null || _aboutValue == "") {
      showSnackBar(context, 'กรุณาบรรยายข้อมูลเกี่ยวกับร้านค้า');
      _btnController.reset();
      return false;
    }

    Map<String, dynamic> data = {
      'name': _nameValue.toString().trim(),
      'slogan': _sloganValue.toString().trim(),
      'about': _aboutValue.toString().trim(),
      'phone1': _phone1Value.toString().trim(),
      'phone2': _phone2Value.toString().trim(),
      'district': district.toString(),
      'status': 0.toString(),
    };

    try {
      // get current user token
      String token = settingModel.value['token'];
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPointAddStore}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        var stores = storeModel.stores;
        stores.add(jsonData['data']['store']);
        // update state
        storeModel.stores = stores;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OperationScreen()));
      } else {
        showSnackBar(context, "เกิดข้อผิดพลาดไม่สามารถสร้างร้านค้าได้");
      }
    } catch (e) {
      print(e);
      showSnackBar(context, "เกิดข้อผิดพลาดไม่สามารถสร้างร้านค้าได้");
    }
  }

  @override
  void initState() {
    super.initState();
    storeModel = context.read<StoreModel>();
    settingModel = context.read<SettingModel>();
  }

  @override
  Widget build(BuildContext context) {
    // Edit Button
    final submitButton = RoundedLoadingButton(
      child: Text(
        "สร้างร้านค้า",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        _onSubmit();
        _btnController.stop();
      },
    );

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _chosenDistrict,
              isExpanded: true,
              hint: Text(
                "เขตอำเภอ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
              ),
              items: <String>['กันทรลักษณ์', 'ขุนหาญ', 'ศรีรัตนะ']
                  .map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenDistrict = value;
                });
              },
            ),
          ),
          RoundedInputField(
            hintText: "ชื่อร้านค้า",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _nameValue = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "สโลแกนร้านค้า",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _sloganValue = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เบอร์โทรติดต่อหลัก",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _phone1Value = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เบอร์โทรติดต่อสำรอง (ถ้ามี)",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _phone2Value = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เกี่ยวกับร้านค้า",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _aboutValue = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: submitButton,
          )
        ],
      ),
    );
  }
}
