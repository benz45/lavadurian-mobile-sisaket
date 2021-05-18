import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as Http;
import 'package:provider/provider.dart';

showDialogSetStoreStatus(BuildContext context, int storeID, int currentStatus) {
  SettingModel settingModel = Provider.of<SettingModel>(context, listen: false);
  StoreModel storeModel = Provider.of<StoreModel>(context, listen: false);
  UserModel userModel = Provider.of<UserModel>(context, listen: false);

  // Number random
  int numberRandom = Random().nextInt(90) + 10;
  int newStatus = 0;

  TextEditingController controllerNumber = TextEditingController();

  void _changeStatus() async {
    if (controllerNumber.text != '$numberRandom') {
      showFlashBar(context, message: 'หมายเลขที่กรอกไม่ถูกต้อง', warning: true);
    } else {
      List<Map<String, dynamic>> stores = storeModel.getStores;
      int index = stores.indexWhere((element) => element['id'] == storeID);
      Map<String, dynamic> store = stores[index];

      /**
       * * Setup new status
       * */
      if (currentStatus == 1) {
        newStatus = 3;
      } else {
        newStatus = 1;
      }

      // get current user token
      String token = settingModel.value['token'];

      Map<String, dynamic> data = {
        'store': store['id'].toString(),
        'status': newStatus.toString(),
      };

      try {
        final response = await Http.post(
          '${settingModel.baseURL}/${settingModel.endPointSetStoreStatus}',
          body: data,
          headers: {HttpHeaders.authorizationHeader: "Token $token"},
        );

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
          if (jsonData['status'] == true) {
            /**
             *  Update state of store
             * */
            stores[index] = jsonData['data']['store'];
            storeModel.setStores = stores;

            showFlashBar(context, message: 'ปรับสถานะร้านค้าเรียบร้อยแล้ว', success: true, duration: 3500);
            Navigator.pop(context);
          }
        } else {
          showFlashBar(context, message: 'ปรับสถานะข้อมูลไม่สำเร็จ code: ${response.statusCode}', error: true);
        }
      } catch (e) {
        showFlashBar(context, message: 'ปรับสถานะข้อมูลไม่สำเร็จ', error: true);
      }
    }
  }

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'ปรับสถานะของร้านค้า',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(29),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'ปรับสถานะร้านค้าของท่านใหม่',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            Divider(),
            Text(
              'หากต้องปรับสถานะของร้านค้านี้ให้พิมพ์หมายเลขด้านล่างลงในช่องว่างและกด "ตกลง"',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                '$numberRandom',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            RoundedInputField(
              autofocus: true,
              maxLines: 1,
              controller: controllerNumber,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(
              height: 16,
            ),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 12),
              minWidth: double.infinity,
              color: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(19),
                ),
              ),
              onPressed: _changeStatus,
              child: Text(
                'ตกลง',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            FlatButton(
              minWidth: double.infinity,
              color: Colors.grey[300],
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(19))),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: kTextPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
