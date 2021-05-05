import 'dart:convert';

import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/Screens/SocialQRCode/components/select_qrcode_container.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:smart_select/smart_select.dart';

class QRCodeUpload extends StatefulWidget {
  @override
  _QRCodeUploadState createState() => _QRCodeUploadState();
}

class _QRCodeUploadState extends State<QRCodeUpload> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // * progress dialog
  ProgressDialog pr;

  final int maxImageLimit = 1;
  bool isSelectedImage = false;

  // List image for preview only, dynamic type.
  List<dynamic> listImageForPreview = [];

  // List image for upload only, asset type only.
  List<Asset> listImagesForUpload = [];

  SettingModel settingModel;
  StoreModel storeModel;
  QRCodeModel qrCodeModel;

  // Social value
  int socialValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingModel = context.read<SettingModel>();
    storeModel = context.read<StoreModel>();
    qrCodeModel = context.read<QRCodeModel>();

    // * setup progress dialog
    pr = ProgressDialog(context);
    pr.style(
      message: 'กำลังอัพโหลดรุปภาพ...',
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

  /*
   * For upload image by using MultipathRequest
  */
  Future<Null> _uploadProcess({@required List<Asset> listImageForUpload, @required int storeID}) async {
    // get current user token
    String token = settingModel.value['token'];

    // string to uri
    Uri uri = Uri.parse('${settingModel.baseURL}/${settingModel.endPointAddQRCode}');

    // create multipart request
    MultipartRequest request = MultipartRequest("POST", uri);

    for (Asset asset in listImageForUpload) {
      ByteData byteData = await asset.getByteData(quality: 60);
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

    // * adding params Store ID
    request.fields['store'] = "$storeID";

    // * adding params Social ID (1:Facebook, 2:Line)
    request.fields['social'] = "$socialValue";

    // Upload photo and wait for response
    try {
      pr.show();

      // * Send POST data to server
      Response response = await Response.fromStream(await request.send());

      // * encode reponse data
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      pr.hide();

      if (response.statusCode == 200 && jsonData['status']) {
        qrCodeModel.addNewQRCode(jsonData['data']);
        showFlashBar(context, message: 'อัพโหลดรูปภาพสำเร็จ', success: true);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OperationScreen(),
          ),
        );
      }
    } catch (e) {
      showFlashBar(context, message: 'เกิดข้อผิดพลาดบางอย่าง', error: true);
      pr.hide();
      print(e.toString());
    }
  }

  /*
   * For load load image from device gallery
  */
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

  /*
   * On Remove image selected
  */
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

  void _onShowDialogConfirmRemove(int imgID) {
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
                  // _deleteImage(productID, imgID);
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(19))),
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
    Size size = MediaQuery.of(context).size;
    final font = Theme.of(context).textTheme;

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
              padding: EdgeInsets.only(left: size.width * 0.09),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
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
                          "Social Media QR Code",
                          style: TextStyle(fontSize: font.headline6.fontSize, color: kTextPrimaryColor),
                        ),
                        Text(
                          "เลือกภาพคิวอาร์โค้ดของโซเชียลมีเดีย",
                          style: TextStyle(fontSize: font.subtitle2.fontSize, color: kTextSecondaryColor),
                        ),
                        Text(
                          "เพื่อเพิ่มช่องทางในการติดต่อกับผู้ซื้อสินค้ากับทางร้าน",
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
              child: SizedBox(
                width: size.width / 1.5,
                child: _socialChoice(context),
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
                                                    'ไม่พบรูป',
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
                            height: size.height * 0.55,
                            child: Center(
                              child: SelectQRCodeContainer(
                                title: "เลือก QR Code",
                                onPressed: () => loadAssets(),
                              ),
                            ),
                          ),
                      ],
                    )
                  : _ChooseQRCodeBox(context),
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
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
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
                    ? () => _uploadProcess(listImageForUpload: listImagesForUpload, storeID: storeModel.getCurrentIdStore)
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

  // * widget for select qrcode image when image is empty
  Widget _ChooseQRCodeBox(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.55,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SelectQRCodeContainer(
              title: "เลือก QR Code",
              onPressed: () => loadAssets(),
            ),
          ],
        ),
      ),
    );
  }

  // * Gender choice widget
  Widget _socialChoice(BuildContext context) {
    List<S2Choice<int>> options = [
      S2Choice<int>(value: 1, title: 'Facebook'),
      S2Choice<int>(value: 2, title: 'Line'),
    ];

    return SmartSelect<int>.single(
      title: 'Social Media',
      value: socialValue,
      choiceDivider: false,
      modalConfirm: false,
      choiceItems: options,
      modalType: S2ModalType.popupDialog,
      modalStyle: S2ModalStyle(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        clipBehavior: Clip.antiAlias,
      ),
      modalHeaderStyle: S2ModalHeaderStyle(
        centerTitle: false,
      ),
      onChange: (state) => setState(() => socialValue = state.value),
    );
  }
}
