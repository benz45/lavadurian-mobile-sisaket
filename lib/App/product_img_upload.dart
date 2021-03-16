import 'dart:convert';
import 'dart:typed_data';

import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProductImageUpload extends StatefulWidget {
  @override
  _ProductImageUploadState createState() => new _ProductImageUploadState();
}

class _ProductImageUploadState extends State<ProductImageUpload> {
  SettingModel settingModel;
  List<Asset> images = List<Asset>();
  String textError;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 1,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            margin: EdgeInsets.all(15),
            child: AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) textError = 'No Error Dectected';
    });
  }

  // For upload data by using MultipathRequest
  Future<Null> _uploadProcess() async {
    // get current user token
    String token = settingModel.value['token'];

    // string to uri
    Uri uri = Uri.parse(
        '${settingModel.baseURL}/${settingModel.endPointUploadProductImage}');

    // create multipart request
    MultipartRequest request = MultipartRequest("POST", uri);

    for (Asset asset in images) {
      ByteData byteData = await asset.getByteData(quality: 30);
      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'image',
        imageData,
        filename: 'image.jpg',
      );

      // add access token to header
      request.headers['authorization'] = "Token $token";

      // add file to multipart
      request.files.add(multipartFile);

      //adding params Product ID
      request.fields['product'] = '178';

      // Upload photo and wait for response
      Response response = await Response.fromStream(await request.send());
      final jsonData = jsonDecode(response.body);
      if (jsonData['status']) {
        _btnController.success();
      } else {
        _btnController.error();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Login Button
    final uploadButton = RoundedLoadingButton(
      child: Text(
        "UPLOAD PHOTO",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () => _uploadProcess(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Product Image"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "ภาพผลิตภัณฑ์สำหรับประชาสัมพันธ์",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                child: Center(
                  child: images == null || images.length == 0
                      ? Text("ยังไม่มีภาพที่ถูกเลือก")
                      : buildGridView(),
                ),
              ),
            ),
            images != null && images.length != 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        uploadButton,
                        // cancelButton,
                      ],
                    ),
                  )
                : Text("")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => loadAssets(),
        tooltip: "pickImage",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
