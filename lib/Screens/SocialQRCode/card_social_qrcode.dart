import 'package:LavaDurian/Screens/SocialQRCode/delete_dialog.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardSocialQRCode extends StatefulWidget {
  @override
  _CardSocialQRCodeState createState() => _CardSocialQRCodeState();
}

class _CardSocialQRCodeState extends State<CardSocialQRCode> {
  List<String> imgUrl = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<StoreModel>(
      builder: (context, storeModel, child) {
        return Container(
          padding: EdgeInsets.all(22),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.04),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
          width: size.width * 0.9,
          child: Row(
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Line & Facebook QR Code',
                      style: TextStyle(
                          fontSize: textTheme.subtitle2.fontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GridView.count(
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
                                width: size.width * .5,
                                child: Card(
                                  margin: EdgeInsets.all(10),
                                  semanticContainer: true,
                                  color: Colors.white,
                                  elevation: 5,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Image.network(
                                    imgUrl[index],
                                    fit: BoxFit.cover,
                                  ),
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
                                        color:
                                            Colors.green[100].withOpacity(0.9),
                                        child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  QRCodeDeleteDialog(),
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
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
