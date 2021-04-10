import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/UploadImageProductScreen/components/select_Image_product_container.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
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
        // * update state
        // * rebuild widget
        // ! bug is here.
        setState(() {
          productImageModel.images
              .removeWhere((element) => element['id'] == imgID);
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
                  Navigator.pop(context);
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
  }
}
