import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/EditStore/components/show_dialog_delete_store.dart';
import 'package:LavaDurian/Screens/EditStore/components/show_dialog_set_store_status.dart';
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

  bool _isChosenDistrict = false;
  bool _isNameValue = false;
  bool _isSloganValue = false;
  bool _isPhone1Value = false;
  bool _isPhone2Value = false;
  bool _isAboutValue = false;

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

  bool _isSwitched;

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  int storeId;
  @override
  void initState() {
    super.initState();
    storeId = widget.storeID;
    storeModel = context.read<StoreModel>();
    settingModel = context.read<SettingModel>();
  }

  Future<void> _onSubmit() async {
    String district;
    // validate data
    if (_chosenDistrict == null) {
      showSnackBar(context, 'กรุณาเลือกเขตอำเภอ');
      _btnController.reset();
      return false;
    } else {
      district = storeModel.district.keys.firstWhere((element) => storeModel.district[element] == _chosenDistrict);
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

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonData['status'] == true) {
          storeModel.updateStores(storeId: storeId, value: jsonData['data']['store']);
          showFlashBar(context, message: 'แก้ไขข้อมูลร้านค้าเรียบร้อยแล้ว', success: true, duration: 3500);

          _btnController.success();
          Navigator.pop(context);
        } else {
          print(jsonData['status']);
        }
      } else {
        showFlashBar(context, message: 'บันทึกข้อมูลไม่สำเร็จ code: ${response.statusCode}', error: true);
      }
    } catch (e) {
      print(e);
      showFlashBar(context, message: 'เกิดข้อผิดพลาดไม่สามารถอัปเดได้', error: true);
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    // get current store
    stores = storeModel.getStores;
    store = stores.firstWhere((element) => element['id'] == widget.storeID);

    /**
     * * Set store status swtich
     * */
    String statusMsg = '';
    if (store['status'] == 1) {
      _isSwitched = true;
      statusMsg = "ไม่พร้อมขาย";
    } else {
      _isSwitched = false;
      statusMsg = "พร้อมขาย";
    }

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
      borderRadius: 10,
      onPressed: () {
        _onSubmit();
        _btnController.stop();
      },
    );

    return Padding(
      padding: EdgeInsets.all(26.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  'แก้ไขรายละเอียดร้านค้า',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // * ชื่อร้านค้า
          InkWell(
            onTap: () {
              setState(() {
                _isNameValue = !_isNameValue;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ชื่อร้านค้า',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                    Text(
                      '$_nameValue',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                  ],
                ),
                if (!_isNameValue)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: kTextSecondaryColor,
                  ),
                if (_isNameValue)
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: kTextSecondaryColor,
                  )
              ],
            ),
          ),
          if (_isNameValue)
            RoundedInputField(
              hintText: "ชื่อร้านค้า",
              icon: Icons.add_circle_outline,
              onChanged: (v) => _nameValue = v,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              controller: _controllerNameValue,
              // inputFormatters: limitingTextInput,
            ),
          Divider(),
          // * ชื่อร้านค้า
          InkWell(
            onTap: () {
              setState(() {
                _isSloganValue = !_isSloganValue;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สโลแกนร้านค้า',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                    Text(
                      '$_sloganValue',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                  ],
                ),
                if (!_isSloganValue)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: kTextSecondaryColor,
                  ),
                if (_isSloganValue)
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: kTextSecondaryColor,
                  )
              ],
            ),
          ),
          if (_isSloganValue)
            RoundedInputField(
              hintText: "สโลแกนร้านค้า",
              icon: Icons.add_circle_outline,
              onChanged: (v) => _sloganValue = v,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              controller: _controllerSloganValue,
              // inputFormatters: limitingTextInput,
            ),
          Divider(),
          // * เบอร์โทรติดต่อหลัก
          InkWell(
            onTap: () {
              setState(() {
                _isPhone1Value = !_isPhone1Value;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เบอร์โทรติดต่อหลัก',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                    Text(
                      '$_phone1Value',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                  ],
                ),
                if (!_isPhone1Value)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: kTextSecondaryColor,
                  ),
                if (_isPhone1Value)
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: kTextSecondaryColor,
                  )
              ],
            ),
          ),
          if (_isPhone1Value)
            RoundedInputField(
              hintText: "เบอร์โทรติดต่อหลัก",
              icon: Icons.add_circle_outline,
              onChanged: (v) => _phone1Value = v,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: _controllerPhone1Value,
              // inputFormatters: limitingTextInput,
            ),
          Divider(),
          // * เบอร์โทรติดต่อสำรอง
          InkWell(
            onTap: () {
              setState(() {
                _isPhone2Value = !_isPhone2Value;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เบอร์โทรติดต่อสำรอง',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                    Text(
                      _phone2Value != "" ? '$_phone2Value' : 'ไม่ได้ระบุ',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                  ],
                ),
                if (!_isPhone2Value)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: kTextSecondaryColor,
                  ),
                if (_isPhone2Value)
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: kTextSecondaryColor,
                  )
              ],
            ),
          ),
          if (_isPhone2Value)
            RoundedInputField(
              hintText: "เบอร์โทรติดต่อสำรอง (ถ้ามี)",
              icon: Icons.add_circle_outline,
              onChanged: (v) => _phone2Value = v,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: _controllerPhone2Value,
              // inputFormatters: limitingTextInput,
            ),
          Divider(),
          // * เขตอำเภอ
          InkWell(
            onTap: () {
              setState(() {
                _isChosenDistrict = !_isChosenDistrict;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เขตอำเภอ',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                    Text(
                      '$_chosenDistrict',
                      style: TextStyle(color: kTextSecondaryColor),
                    ),
                  ],
                ),
                if (!_isChosenDistrict)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: kTextSecondaryColor,
                  ),
                if (_isChosenDistrict)
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: kTextSecondaryColor,
                  )
              ],
            ),
          ),
          if (_isChosenDistrict)
            DropdownButton<String>(
              value: _chosenDistrict,
              isExpanded: true,
              hint: Text(
                "เขตอำเภอ",
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
              ),
              items: <String>['กันทรลักษณ์', 'ขุนหาญ', 'ศรีรัตนะ'].map((String value) {
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
          Divider(),
          // * เกี่ยวกับร้านค้า
          InkWell(
            onTap: () {
              setState(() {
                _isAboutValue = !_isAboutValue;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เกี่ยวกับร้านค้า',
                        style: TextStyle(color: kTextSecondaryColor),
                      ),
                      Text(
                        '$_aboutValue',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: kTextSecondaryColor),
                      ),
                    ],
                  ),
                ),
                if (!_isAboutValue)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: kTextSecondaryColor,
                  ),
                if (_isAboutValue)
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: kTextSecondaryColor,
                  )
              ],
            ),
          ),
          if (_isAboutValue)
            RoundedInputField(
              hintText: "เกี่ยวกับร้านค้า",
              icon: Icons.add_circle_outline,
              onChanged: (v) => _aboutValue = v,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              controller: _controllerAboutValue,
            ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: submitButton,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  'ตั้งค่าเพิ่มเติม',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // ! ไม่พร้อมขาย
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ปรับสถานะของร้านใหม่เป็น "$statusMsg"',
                style: TextStyle(
                  color: kTextSecondaryColor,
                ),
              ),
              Switch(
                value: _isSwitched,
                onChanged: (_) {
                  setState(() {
                    showDialogSetStoreStatus(context, storeId, store['status']);
                    _isSwitched = !_isSwitched;
                  });
                },
                activeTrackColor: Colors.red[200],
                activeColor: Colors.red[600],
              ),
            ],
          ),
          Divider(),
          // ! Remove store
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'หากต้องการลบร้านค้านี้',
                    style: TextStyle(
                      color: kTextSecondaryColor,
                    ),
                  ),
                ],
              ),
              Center(
                child: OutlineButton(
                  color: kErrorColor.withOpacity(0.15),
                  borderSide: BorderSide(
                    color: kErrorColor.withOpacity(0.6),
                  ),
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                  splashColor: kErrorColor.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "ลบ",
                    style: TextStyle(color: kErrorColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => showDialogDeleteStore(context, storeId),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
