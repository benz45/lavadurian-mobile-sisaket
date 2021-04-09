import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class ImageSelected extends StatefulWidget {
  final int productID;
  const ImageSelected({Key key, this.productID}) : super(key: key);
  @override
  _ImageSelectedState createState() => _ImageSelectedState();
}

class _ImageSelectedState extends State<ImageSelected> {
  ProductImageModel productImageModel;
  SettingModel settingModel;

  List imageList;
  int productID;

  List consumeImage(int productID) {
    List list = [];
    for (var image in productImageModel.images) {
      if (image['product'] == productID) {
        list.add(image);
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    productImageModel = context.read<ProductImageModel>();
    settingModel = context.read<SettingModel>();
  }

  Future<void> _deleteImage(int productID, int imgID) async {
    Map<String, dynamic> data = {
      'product': productID.toString(),
      'image': imgID.toString(),
    };

    // get current user token
    String token = settingModel.value['token'];

    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPointDeleteProductImage}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      if (jsonData['status'] == true) {
        setState(() {
          productImageModel.images
              .removeWhere((element) => element['id'] == imgID);
          Navigator.pop(context);
        });
      } else {
        print(jsonData['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _onShowDialogConfirm(int imgID) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          'ลบภาพสินค้า',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'ลบภาพสินค้าออกจากรายการสินค้าปัจจุบัน',
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
                onPressed: () {
                  _deleteImage(productID, imgID);
                  // Navigator.pop(context);
                },
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

  @override
  Widget build(BuildContext context) {
    productID = widget.productID;

    imageList = consumeImage(widget.productID);
    Size size = MediaQuery.of(context).size;

    return imageList.length != 0
        ? GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(12),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
            children: [
              for (var index = 0; index < imageList.length; index++)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    // * Container image.
                    Container(
                      width: (size.height * 0.2).round() + .0,
                      height: (size.height * 0.2).round() + .0,
                      child: Card(
                        margin: EdgeInsets.all(0),
                        semanticContainer: true,
                        elevation: 0.2,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Image.network(imageList[index]['image'],
                            fit: BoxFit.fill),
                      ),
                    ),
                    // * Cancel select image.
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        height: 28,
                        width: 28,
                        child: Center(
                          child: ClipOval(
                            child: Material(
                              color: Colors.white.withOpacity(0.75),
                              child: IconButton(
                                onPressed: () {
                                  // ! To Do Remove Action.
                                  _onShowDialogConfirm(imageList[index]['id']);
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
            ],
          )
        : Container();
  }
}
