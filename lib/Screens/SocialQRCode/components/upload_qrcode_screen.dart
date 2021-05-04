import 'package:LavaDurian/Screens/SocialQRCode/components/select_qrcode_container.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class QRCodeUpload extends StatefulWidget {
  @override
  _QRCodeUploadState createState() => _QRCodeUploadState();
}

class _QRCodeUploadState extends State<QRCodeUpload> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final int maxImageLimit = 3;
  bool isSelectedImage = false;

  // List image for preview only, dynamic type.
  List<dynamic> listImageForPreview = [];

  // List image for upload only, asset type only.
  List<Asset> listImagesForUpload = [];

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
                          "เพื่อเพิ่มช่องทางในการติดต่อกับผู้ซื้อสินค้าจากทางร้าน",
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
                  ? Container()
                  : Container(
                      height: size.height * 0.55,
                      child: Center(
                        child: SelectQRCodeContainer(
                          title: "เลือก QR Code",
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
                onPressed: isSelectedImage && listImagesForUpload.length != 0 ? () {} : null,
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
