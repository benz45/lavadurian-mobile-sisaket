import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/SocialQRCode/components/qrcode_img_cache_container.dart';
import 'package:LavaDurian/Screens/SocialQRCode/components/select_qrcode_container.dart';
import 'package:LavaDurian/Screens/SocialQRCode/components/upload_qrcode_screen.dart';
import 'package:LavaDurian/components/dialog_confirm.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class CardSocialQRCode extends StatefulWidget {
  @override
  _CardSocialQRCodeState createState() => _CardSocialQRCodeState();
}

class _CardSocialQRCodeState extends State<CardSocialQRCode> {
  QRCodeModel qrCodeModel;
  SettingModel settingModel;

  // * Delete QRCode.
  Future<Null> _deleteQRCode(int storeID, int qrcodeID) async {
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
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer2<StoreModel, QRCodeModel>(
      builder: (context, storeModel, qrCodeModel, child) {
        /*
        * get current QRCode Image
        */
        var qrcodes = qrCodeModel.getQRCodeFromStoreId(storeModel.getCurrentIdStore);

        List<dynamic> imgUrl = [];
        if (qrcodes.length != 0) {
          for (var i = 0; i < qrcodes.length; i++) {
            imgUrl.add(qrcodes[i]['qr_code']);
          }
        }

        return Container(
          padding: EdgeInsets.all(22),
          width: size.width * 0.9,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.04),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Line & Facebook QR Code',
                style: TextStyle(fontSize: textTheme.subtitle2.fontSize, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              imgUrl.length > 0
                  ? GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(12),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      crossAxisCount: 2,
                      children: [
                        for (var index = 0; index < imgUrl.length; index++)
                          Container(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Card(
                                  margin: EdgeInsets.all(0),
                                  semanticContainer: true,
                                  elevation: 1,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: QRCodeCachedImageNetwork(imgUrl: imgUrl[index]),
                                ),
                                Positioned(
                                  right: 9,
                                  top: 6,
                                  child: Container(
                                    height: 28,
                                    width: 28,
                                    child: Center(
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.green[100].withOpacity(0.9),
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => CustomConfirmDialog(
                                                  title: "ต้องการลบ QR Code !",
                                                  subtitle: "กรุณากดปุ่มยืนยันเพื่อลบภาพคิวอาร์โค๊ดออกจากร้านค้า",
                                                  onpress: () async {
                                                    await _deleteQRCode(qrcodes[index]['store'], qrcodes[index]['id']);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                // QRCodeDeleteDialog(qrcodeID: qrcodes[index]['id'], storeID: qrcodes[index]['store']),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 13,
                                            ),
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (imgUrl.length < 2) _uploadIcon(context),
                      ],
                    )
                  : _uploadIcon(context),
            ],
          ),
        );
      },
    );
  }

  Widget _uploadIcon(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double extendedScreen = 0.2;
    if (size.width >= 600.0) {
      extendedScreen = 0.3;
    }

    return Center(
      child: Container(
        width: (size.height * extendedScreen).round() + .0,
        height: (size.height * extendedScreen).round() + .0,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SelectQRCodeContainer(
            title: "อัปโหลด",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRCodeUpload()),
              );
            },
          ),
        ),
      ),
    );
  }
}
