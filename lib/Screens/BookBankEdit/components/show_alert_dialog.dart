import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/components/dialog_confirm.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
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
          showFlashBar(context, message: 'ลบหมายเลขบัญชีเรียบร้อยแล้ว', success: true, duration: 3500);
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
    builder: (context) => CustomConfirmDialog(
      title: 'ยืนยันลบหมายบัญชีนี้',
      subtitle: 'ระบบจะทำการลบหมายบัญชีนี้หลังจากยืนยันแล้ว',
      onpress: () {
        _deleteBookbank();
      },
    ),
  );
}
