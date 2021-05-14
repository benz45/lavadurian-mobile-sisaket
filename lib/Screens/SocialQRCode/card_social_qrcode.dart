import 'package:LavaDurian/Screens/SocialQRCode/components/qrcode_img_cache_container.dart';
import 'package:LavaDurian/Screens/SocialQRCode/components/select_qrcode_container.dart';
import 'package:LavaDurian/Screens/SocialQRCode/components/delete_dialog.dart';
import 'package:LavaDurian/Screens/SocialQRCode/components/upload_qrcode_screen.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardSocialQRCode extends StatefulWidget {
  @override
  _CardSocialQRCodeState createState() => _CardSocialQRCodeState();
}

class _CardSocialQRCodeState extends State<CardSocialQRCode> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer2<StoreModel, QRCodeModel>(
      builder: (context, storeModel, qrCodeModel, child) {
        List<String> imgUrl = [];

        // * Fillter qr code in current store
        var qrcodes = qrCodeModel.getQRCodeFromStoreId(storeModel.getCurrentIdStore);

        if (qrcodes.length != 0) {
          for (var i = 0; i < qrcodes.length; i++) {
            imgUrl.add(qrcodes[i]['qr_code']);
          }
        }

        return Container(
          padding: EdgeInsets.all(22),
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
          width: size.width * 0.9,
          child: Row(
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Line & Facebook QR Code',
                      style: TextStyle(fontSize: textTheme.subtitle2.fontSize, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // * if already upload 2 qr code.
                    imgUrl.length > 0
                        ? GridView.count(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(12),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            crossAxisCount: 2,
                            children: [
                              for (var index = 0; index < imgUrl.length; index++)
                                Stack(
                                  children: [
                                    Container(
                                      width: (size.height * 0.2).round() + .0,
                                      height: (size.height * 0.2).round() + .0,
                                      child: Card(
                                        margin: EdgeInsets.all(10),
                                        semanticContainer: true,
                                        color: Colors.white,
                                        elevation: 5,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                        ),
                                        child: QRCodeCachedImageNetwork(imgUrl: imgUrl[index]),
                                      ),
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
                                                    builder: (_) =>
                                                        QRCodeDeleteDialog(qrcodeID: qrcodes[index]['id'], storeID: qrcodes[index]['store']),
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
                              if (imgUrl.length < 2) _uploadIcon(context),
                            ],
                          )
                        : _uploadIcon(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _uploadIcon(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: (size.height * 0.2).round() + .0,
        height: (size.height * 0.2).round() + .0,
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
