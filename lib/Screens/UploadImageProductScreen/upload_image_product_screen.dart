import 'dart:convert';
import 'dart:typed_data';

import 'package:LavaDurian/Screens/UploadImageProductScreen/components/image_selected.dart';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'components/select_Image_product_container.dart';

class ProductImageUpload extends StatefulWidget {
  final productId;
  final Function onPressed;
  ProductImageUpload({this.productId, this.onPressed});
  @override
  _ProductImageUploadState createState() => new _ProductImageUploadState();
}

class _ProductImageUploadState extends State<ProductImageUpload> {
  int productID;
  SettingModel settingModel;
  ProductImageModel productImageModel;

  final int imageLimit = 3;
  int remainImage;

  List<Asset> images = List<Asset>();
  String textError;
  bool isSelectedImage = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    productImageModel = context.read<ProductImageModel>();
  }

  int _imageCount(int productID) {
    int count = 0;
    for (var image in productImageModel.images) {
      if (image['product'] == productID) {
        count += 1;
      }
    }
    return count;
  }

  // Seledt image from device
  Future<void> loadAssets() async {
    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages:
            images.length < remainImage ? remainImage - images.length : 0,
      );
    } on Exception catch (e) {
      // Set previous images if user cancel select image.
      if (images.length != 0) {
        resultList = images;
      }
      error = e.toString();
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (images.length != 0) {
      // Add image if images not fully. (3 Image).
      if (images.length < remainImage &&
          (resultList.length + images.length) <= remainImage) {
        setState(() {
          images.addAll(resultList);
          isSelectedImage = true;
          if (error == null) textError = 'เลือกรูปสำเร็จ';
        });
        return;
      }

      // Add image if image fully. (3 Image).
      else if (images.length == remainImage && resultList.length != 0) {
        setState(() {
          images.removeRange(0, resultList.length);
          images.addAll(resultList);
          isSelectedImage = true;
          if (error == null) textError = 'เลือกรูปสำเร็จ';
        });
        return;
      }
    }
    // First select image.
    else if (resultList.length != 0) {
      setState(() {
        images = resultList;
        isSelectedImage = true;
        if (error == null) textError = 'เลือกรูปสำเร็จ';
      });
      return;
    }
  }

  // On Remove image selected
  void _onRemoveImageSelected(element) {
    setState(() {
      images.removeAt(element);
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
    }

    //adding params Product ID
    request.fields['product'] = widget.productId.toString();

    // Upload photo and wait for response
    try {
      Response response = await Response.fromStream(await request.send());
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == true) {
        for (var imageData in jsonData['data']) {
          productImageModel.images.add(imageData);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProductScreen(productId: productID),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // * setup product id
    productID = widget.productId;

    // Media Query
    final double appBarHeight = 66;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final font = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;

    // * count uploaded product image
    int imageCount = _imageCount(productID);

    // * setup remain image that user can upload
    remainImage = imageLimit - imageCount;

    // Login Button
    final uploadButton = RoundedLoadingButton(
      child: Text(
        "UPLOAD PHOTO",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: size.width,
      color: kPrimaryColor,
      onPressed: () => _uploadProcess(),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            elevation: 0,
            shadowColor: Colors.grey[50].withOpacity(0.3),
            backgroundColor: Colors.white,
            pinned: true,
            // expandedHeight: size.height * 0.19,
            expandedHeight: size.height * 0.15,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: EdgeInsets.only(left: size.width * 0.09),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_rounded),
                color: kTextPrimaryColor,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                height: statusBarHeight + appBarHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ภาพผลิตภัณฑ์สำหรับประชาสัมพันธ์",
                          style: TextStyle(
                              fontSize: font.headline6.fontSize,
                              color: kTextPrimaryColor),
                        ),
                        Text(
                          "สามารถเลือกรูปภาพได้สูงสุด 3 รูปภาพ",
                          style: TextStyle(
                              fontSize: font.subtitle2.fontSize,
                              color: kTextSecondaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            sliver: SliverToBoxAdapter(
              child: ImageSelected(productID: productID),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            sliver: SliverToBoxAdapter(
              child: images.length != 0
                  ? GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(12),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      crossAxisCount: 2,
                      children: [
                          for (var index = 0; index < images.length; index++)
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
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
                                    child: AssetThumb(
                                      asset: images[index],
                                      width: (size.height * 0.2).round(),
                                      height: (size.height * 0.2).round(),
                                    ),
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
                                            onPressed: () =>
                                                _onRemoveImageSelected(index),
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
                          SelectImageProductContainer(
                            onPressed: () => loadAssets(),
                          ),
                        ])
                  :
                  // * First container select image.
                  Container(
                      height: size.height * 0.19,
                      child: Center(
                          child: SelectImageProductContainer(
                        onPressed: () => loadAssets(),
                      )),
                    ),
            ),
          ),
        ],
      ),

      // * Button upload image.
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 36, horizontal: size.width * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: OutlineButton(
                highlightColor: kPrimaryLightColor,
                highlightedBorderColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: size.width * 0.10),
                color: kPrimaryColor,
                // onPressed: widget.onPressed ?? () => Navigator.pop(context),
                onPressed: widget.onPressed ??
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewProductScreen(productId: productID))),
                child: Text(
                  widget.onPressed != null ? 'ไม่ใช่ตอนนี้' : 'ยกเลิก',
                  style: TextStyle(color: kPrimaryColor, fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: FlatButton(
                disabledColor: kTextSecondaryColor.withOpacity(0.12),
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: size.width * 0.10),
                color: kPrimaryColor,
                onPressed: isSelectedImage && images.length != 0
                    ? () {
                        _uploadProcess();
                      }
                    : null,
                child: Text(
                  'อัพโหลด',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
