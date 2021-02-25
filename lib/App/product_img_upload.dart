import 'dart:typed_data';

import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class ProductImageUpload extends StatefulWidget {
  @override
  _ProductImageUploadState createState() => new _ProductImageUploadState();
}

class _ProductImageUploadState extends State<ProductImageUpload> {
  SettingModel settingModel;
  List<Asset> images = List<Asset>();
  String _error;

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
      if (error == null) _error = 'No Error Dectected';
    });
  }

  // For upload data
  Future<Null> _uploadProcess() async {
    // get current user token
    String token = settingModel.value['token'];

    // string to uri
    Uri uri = Uri.parse(
        '${settingModel.baseURL}/${settingModel.endPointUploadProductImage}');

    // create multipart request
    MultipartRequest request = MultipartRequest("POST", uri);

    for (Asset asset in images) {
      ByteData byteData = await asset.getByteData(quality: 80);
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

      // send
      var response = await request.send();
      print(token);
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    RaisedButton uploadButton = RaisedButton(
      onPressed: () => _uploadProcess(),
      color: kPrimaryColor,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Text(
        'Upload Photo',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

    RaisedButton cancelButton = RaisedButton(
      onPressed: () {},
      color: kPrimaryColor,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Text(
        'Cancel Upload',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Image Picker Example"),
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
                  child: images.isEmpty
                      ? Text("ยังไม่มีภาพที่ถูกเลือก")
                      : buildGridView(),
                ),
              ),
            ),
            images.isNotEmpty
                ? ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[uploadButton, cancelButton],
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
