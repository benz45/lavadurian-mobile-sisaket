import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
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
  final int storeID;

  const BodyEdit({Key key, @required this.storeID}) : super(key: key);
  @override
  _BodyEditState createState() => _BodyEditState();
}

class _BodyEditState extends State<BodyEdit> {
  String _chosenDistrict;
  String _nameValue;
  String _sloganValue;
  String _phone1Value;
  String _phone2Value;
  String _aboutValue;
  List<Map<String, dynamic>> stores;
  Map<String, dynamic> store;

  // controller
  TextEditingController _controllerNameValue;
  TextEditingController _controllerSloganValue;
  TextEditingController _controllerPhone1Value;
  TextEditingController _controllerPhone2Value;
  TextEditingController _controllerAboutValue;

  StoreModel storeModel;
  SettingModel settingModel;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<void> _onSubmit() async {
    String district;
    // validate data
    if (_chosenDistrict == null) {
      showSnackBar(context, 'กรุณาเลือกเขตอำเภอ');
      _btnController.reset();
      return false;
    } else {
      district = storeModel.district.keys.firstWhere(
          (element) => storeModel.district[element] == _chosenDistrict);
    }

    if (_nameValue == "") {
      showSnackBar(context, 'กรุณากรอกชื่อร้านค้า');
      _btnController.reset();
      return false;
    }
    if (_sloganValue == "") {
      showSnackBar(context, 'กรุณากรอกข้อมูลสโลแกนร้านค้า');
      _btnController.reset();
      return false;
    }
    if (_phone1Value == "") {
      showSnackBar(context, 'กรุณากรอกหมายเลขติดต่อ');
      _btnController.reset();
      return false;
    }
    if (_aboutValue == "") {
      showSnackBar(context, 'กรุณาบรรยายข้อมูลเกี่ยวกับร้านค้า');
      _btnController.reset();
      return false;
    }

    Map<String, dynamic> data = {
      'id': store['id'].toString(),
      'name': _nameValue,
      'slogan': _sloganValue,
      'about': _aboutValue,
      'phone1': _phone1Value,
      'phone2': _phone2Value,
      'district': district.toString(),
      'status': store['status'].toString(),
    };
    try {
      // get current user token
      String token = settingModel.value['token'];

      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPoinEditStore}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        jsonData['data']['store']['id'] = widget.storeID;

        int index =
            stores.indexWhere((element) => element['id'] == widget.storeID);

        // update state
        stores[index] = jsonData['data']['store'];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewStoreScreen(widget.storeID)));
      }
    } catch (e) {
      print(e);
      showSnackBar(context, "เกิดข้อผิดพลาดไม่สามารถอัปเดท");
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
    // get current store
    stores = storeModel.getStores;
    store = stores.firstWhere((element) => element['id'] == widget.storeID);

    // initial value
    _controllerNameValue = TextEditingController(text: store['name']);
    _controllerSloganValue = TextEditingController(text: store['slogan']);
    _controllerPhone1Value = TextEditingController(text: store['phone1']);
    _controllerPhone2Value = TextEditingController(text: store['phone2']);
    _controllerAboutValue = TextEditingController(text: store['about']);

    if (_chosenDistrict == null) {
      _chosenDistrict = storeModel.district[store['district'].toString()];
    }

    if (_nameValue == null) _nameValue = store['name'];
    if (_sloganValue == null) _sloganValue = store['slogan'];
    if (_aboutValue == null) _aboutValue = store['about'];
    if (_phone1Value == null) _phone1Value = store['phone1'];
    if (_phone2Value == null) _phone2Value = store['phone2'];

    // Edit Button
    final submitButton = RoundedLoadingButton(
      child: Text(
        "แก้ไขข้อมูลร้านค้า",
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
            controller: _controllerNameValue,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "สโลแกนร้านค้า",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _sloganValue = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: _controllerSloganValue,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เบอร์โทรติดต่อหลัก",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _phone1Value = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: _controllerPhone1Value,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เบอร์โทรติดต่อสำรอง (ถ้ามี)",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _phone2Value = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: _controllerPhone2Value,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เกี่ยวกับร้านค้า",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _aboutValue = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            controller: _controllerAboutValue,
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
