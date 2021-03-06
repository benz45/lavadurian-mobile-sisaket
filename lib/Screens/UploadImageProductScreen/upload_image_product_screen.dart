import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/components/dialog_confirm.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as Http;

import 'components/select_Image_product_container.dart';

class ProductImageUpload extends StatefulWidget {
  final productId;
  final Function onPressed;
  ProductImageUpload({this.productId, this.onPressed});
  @override
  _ProductImageUploadState createState() => new _ProductImageUploadState();
}

class _ProductImageUploadState extends State<ProductImageUpload> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int productID;
  SettingModel settingModel;
  ProductImageModel productImageModel;

  // * progress dialog
  ProgressDialog pr;

  final int maxImageLimit = 3;
  bool isSelectedImage = false;

  // List image for preview only, dynamic type.
  List<dynamic> listImageForPreview = [];

  // List image for upload only, asset type only.
  List<Asset> listImagesForUpload = [];

  @override
  void initState() {
    super.initState();
    productID = widget.productId;
    settingModel = context.read<SettingModel>();
    productImageModel = context.read<ProductImageModel>();

    // * Add init image for preview only from product immage.
    List images = productImageModel.getProductImageFromProductId(productId: productID);
    if (images.length != 0) {
      images.forEach((element) {
        listImageForPreview.add(element);
      });
    }

    // * setup progress dialog
    pr = ProgressDialog(context);
    pr.style(
      message: '??????????????????????????????????????????????????????...',
      borderRadius: 10.0,
      progressWidget: Container(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: kPrimaryColor,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;

    // Seledt image from device
    Future<void> loadAssets() async {
      List<Asset> resultList = [];

      try {
        resultList = await MultiImagePicker.pickImages(
          enableCamera: true,
          maxImages: listImageForPreview.length < maxImageLimit ? maxImageLimit - listImageForPreview.length : 0,
        );
      } on Exception catch (err) {
        print(err);
        // Set previous images if user cancel select image.

        if (!isSelectedImage) {
          setState(() {
            isSelectedImage = false;
          });
        }
        return;
      }

      if (!mounted) return;

      if (listImageForPreview.length != 0) {
        // Add image if images not fully. (3 Image).
        if (listImageForPreview.length < maxImageLimit && (resultList.length + listImageForPreview.length) <= maxImageLimit) {
          setState(() {
            listImagesForUpload.addAll(resultList);
            listImageForPreview.addAll(resultList);

            isSelectedImage = true;
          });
          return;
        }
      }
      // First select image.
      else if (resultList.length != 0) {
        setState(() {
          listImagesForUpload.addAll(resultList);
          listImageForPreview.addAll(resultList);
          isSelectedImage = true;
        });
        return;
      }
    }

    // On Remove image selected
    void _onRemoveImageSelected(Asset asset) {
      for (int i = 0; i < listImageForPreview.length; i++) {
        if (listImageForPreview[i] is Asset) {
          Asset prevStatePreview = listImageForPreview[i];
          if (prevStatePreview.name == asset.name) {
            setState(() => listImageForPreview.removeAt(i));
          }
          for (int j = 0; j < listImagesForUpload.length; j++) {
            Asset prevStateUpload = listImagesForUpload[j];
            if (prevStateUpload.name == asset.name) {
              setState(() => listImagesForUpload.removeAt(j));
            }
          }
        }
      }
    }

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
            expandedHeight: size.height * 0.17,
            automaticallyImplyLeading: false,
            leading: Padding(
              // padding: EdgeInsets.only(left: size.width * 0.09),
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProductScreen(
                        productId: widget.productId,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_back_rounded),
                color: kTextPrimaryColor,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "?????????????????????????????????????????????????????????????????????????????????????????????",
                          style: TextStyle(fontSize: font.headline6.fontSize, color: kTextPrimaryColor),
                        ),
                        Text(
                          "?????????????????????????????????????????????????????????????????????????????? 3 ??????????????????",
                          style: TextStyle(fontSize: font.subtitle2.fontSize, color: kTextSecondaryColor),
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
              child: listImageForPreview.length != 0
                  ? GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(12),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      crossAxisCount: 2,
                      children: [
                        for (var index = 0; index < listImageForPreview.length; index++)
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
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: listImageForPreview[index].runtimeType != Asset
                                        ? CachedNetworkImage(
                                            imageUrl: listImageForPreview[index]['image'],
                                            imageBuilder: (context, imageProvider) => Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    backgroundColor: kPrimaryColor,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.grey[400].withOpacity(.75),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.error_outline_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    '????????????????????????',
                                                    style: TextStyle(color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : AssetThumb(
                                            asset: listImageForPreview[index],
                                            width: (size.height * 0.2).round(),
                                            height: (size.height * 0.2).round(),
                                          )),
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
                                            // TODO : Validate type again
                                            // ! To Do Remove Action.
                                            listImageForPreview[index] is Asset
                                                ? _onRemoveImageSelected(listImageForPreview[index])
                                                : _onShowDialogConfirmRemove(listImageForPreview[index]['id']);
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
                        if (listImageForPreview.length < 3)
                          Container(
                            child: SelectImageProductContainer(
                              onPressed: () => loadAssets(),
                            ),
                          ),
                      ],
                    )
                  : Container(
                      height: size.height * 0.55,
                      child: Center(
                        child: SelectImageProductContainer(
                          onPressed: () => loadAssets(),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),

      // * Bottom action.
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 36, horizontal: size.width * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // * Button cancel .
            Container(
              child: OutlineButton(
                highlightColor: kPrimaryLightColor,
                highlightedBorderColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: size.width * 0.10),
                color: kPrimaryColor,
                onPressed: widget.onPressed ??
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProductScreen(productId: productID))),
                child: Text(
                  widget.onPressed != null ? '????????????????????????????????????' : '??????????????????',
                  style: TextStyle(color: kPrimaryColor, fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            // * Button upload image.
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: FlatButton(
                disabledColor: kTextSecondaryColor.withOpacity(0.12),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: size.width * 0.10),
                color: kPrimaryColor,
                onPressed: isSelectedImage && listImagesForUpload.length != 0
                    ? () => _uploadProcess(listImageForUpload: listImagesForUpload, productId: productID)
                    : null,
                child: Text(
                  '?????????????????????',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // For upload data by using MultipathRequest
  Future<Null> _uploadProcess({@required List<Asset> listImageForUpload, @required int productId}) async {
    // get current user token
    String token = settingModel.value['token'];

    // string to uri
    Uri uri = Uri.parse('${settingModel.baseURL}/${settingModel.endPointUploadProductImage}');

    // create multipart request
    MultipartRequest request = MultipartRequest("POST", uri);

    for (Asset asset in listImageForUpload) {
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
    request.fields['product'] = "$productId";

    // Upload photo and wait for response
    try {
      pr.show();
      Response response = await Response.fromStream(await request.send());
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      if (jsonData['status']) {
        pr.hide();
        productImageModel.addImage(listImage: jsonData['data']);
        showFlashBar(context, message: '?????????????????????????????????????????????????????????', success: true);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProductScreen(productId: productId),
          ),
        );
      }
    } catch (e) {
      showFlashBar(context, message: '??????????????????????????????????????????????????????????????????', error: true);
      pr.hide();
      print(e.toString());
    }
  }

  Future _deleteImage(int productID, int imgID) async {
    Map<String, dynamic> data = {
      'product': "$productID",
      'image': "$imgID",
    };

    // get current user token
    String token = settingModel.value['token'];

    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPointDeleteProductImage}',
        body: data,
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        },
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      if (jsonData['status']) {
        productImageModel.removeProductImageFromImageId(imageId: imgID);
        setState(() {
          listImageForPreview.removeWhere((element) => element.runtimeType != Asset && element['id'] == imgID);
        });
        showFlashBar(context, message: '??????????????????????????????????????????', success: true);
      } else {
        print(jsonData['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _onShowDialogConfirmRemove(int imgID) {
    showDialog(
      context: context,
      builder: (context) => CustomConfirmDialog(
        title: '?????????????????????????????????',
        subtitle: '???????????????????????????????????????????????????????????????????????????????????????????????????????????????',
        onpress: () {
          _deleteImage(productID, imgID);
          Navigator.pop(context);
        },
      ),
    );
  }
}
