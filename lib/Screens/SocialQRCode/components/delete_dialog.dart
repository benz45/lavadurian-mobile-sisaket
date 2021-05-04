import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class QRCodeDeleteDialog extends StatefulWidget {
  final int qrcodeID;
  final int storeID;
  const QRCodeDeleteDialog({Key key, @required this.qrcodeID, @required this.storeID}) : super(key: key);

  @override
  _QRCodeDeleteDialogState createState() => _QRCodeDeleteDialogState();
}

class _QRCodeDeleteDialogState extends State<QRCodeDeleteDialog> {
  QRCodeModel qrCodeModel;
  SettingModel settingModel;

  int storeID;
  int qrcodeID;

  // * Delete QRCode.
  Future<Null> _deleteQRCode() async {
    String token = settingModel.value['token'];
    var response;
    Map<String, String> data = {
      'store': storeID.toString(),
      'qrcode': qrcodeID.toString(),
    };

    try {
      response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPointDeleteQRCode}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonData['status'] == true) {
          qrCodeModel.removeQRCodeById(qrcodeID);
          showFlashBar(context, message: 'ลบ QR Code เรียบร้อยแล้ว', success: true, duration: 3500);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    qrCodeModel = context.read<QRCodeModel>();
    settingModel = context.read<SettingModel>();
  }

  @override
  Widget build(BuildContext context) {
    storeID = widget.storeID;
    qrcodeID = widget.qrcodeID;

    return AlertDialog(
      title: Text(
        "ต้องการลบ QR Code !",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("กรุณากดปุ่มยืนยันเพื่อลบภาพคิวอาร์โค๊ดออกจากร้านค้า"),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Flexible(
                  child: FlatButton(
                    minWidth: double.infinity,
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: FlatButton(
                    minWidth: double.infinity,
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: () async {
                      await _deleteQRCode();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
