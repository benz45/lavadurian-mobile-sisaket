import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

showAlertDialog(BuildContext context, int bookbankID) {
  BookBankModel bookBankModel = context.read<BookBankModel>();
  SettingModel settingModel = context.read<SettingModel>();

  void _deleteBookbank() async {
    Map<String, dynamic> data = {
      'id': bookbankID.toString(),
    };

    // get current user token
    String token = settingModel.value['token'];

    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPoinDeleteBookBank}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonData['status'] == true) {
          showFlashBar(context,
              message: 'ลบหมายเลขบัญชีเรียบร้อยแล้ว',
              success: true,
              duration: 3500);
          bookBankModel.removeBookbank(bookbankId: bookbankID);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      showFlashBar(context, message: 'ลบข้อมูลไม่สำเร็จ', error: true);
      print(e.toString());
    }
  }

  showDialog(
    context: context,
    child: AlertDialog(
      title: Text(
        'ยืนยันลบหมายบัญชีนี้',
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
              'ระบบจะทำการลบหมายบัญชีนี้หลังจากยืนยันแล้ว',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 26,
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
              onPressed: _deleteBookbank,
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(19))),
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
