import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/check_transfer_order_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ViewOrderTransferImage extends StatefulWidget {
  int orderId;
  ViewOrderTransferImage({@required this.orderId});
  @override
  _ViewOrderTransferImageState createState() => _ViewOrderTransferImageState();
}

class _ViewOrderTransferImageState extends State<ViewOrderTransferImage> {
  SettingModel settingModel;

  @override
  void initState() {
    orderId = widget.orderId;
    settingModel = context.read<SettingModel>();
    super.initState();
  }

  Future<CheckTransferOrderModel> _onCheckTransferOrder() async {
    Map<String, int> data = {"order": orderId};

    String url =
        "${settingModel.baseURL}/${settingModel.endPoinGetCheckTransfer}";

    final response = await Http.post(
      url,
      body: jsonEncode(data),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${settingModel.value['token']}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      CheckTransferOrderModel result =
          CheckTransferOrderModel.fromMap(jsonData['data']);

      return result;
    } else {
      throw Exception('Failed to check transfer order.');
    }
  }

  int orderId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        // * Header
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ใบเสร็จชำระเงิน',
                style: TextStyle(
                    height: 1.4,
                    color: kTextSecondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.subtitle1.fontSize),
              ),
              Icon(
                Icons.check_circle,
                color: kPrimaryColor.withOpacity(.75),
                size: Theme.of(context).textTheme.headline5.fontSize,
              )
            ],
          ),
        ),
        FutureBuilder(
          future: _onCheckTransferOrder(),
          builder: (_, snap) {
            CheckTransferOrderModel data = snap?.data;
            return CachedNetworkImage(
              filterQuality: FilterQuality.low,
              cacheKey: data?.transfer?.image,
              imageUrl: data?.transfer?.image,
              imageBuilder: (context, imageProvider) {
                // * Get size image provider of CachedNetworkImage.
                Future<Size> _getSize() async {
                  Completer<Size> completer = Completer();
                  ImageStream _image =
                      imageProvider.resolve(ImageConfiguration());
                  _image.addListener(
                    ImageStreamListener(
                      (ImageInfo image, bool synchronousCall) {
                        var myImage = image?.image;
                        Size size = Size(
                          myImage.width.toDouble(),
                          myImage.height.toDouble(),
                        );
                        completer.complete(size);
                      },
                    ),
                  );

                  Size _s = await completer.future;
                  return _s;
                }

                return FutureBuilder(
                  future: _getSize(),
                  builder: (_, snap) {
                    Size _size = snap?.data;

                    if (_size != null) {
                      return Container(
                        width: _size.width,
                        height: _size.height - (size.width * .30),
                        decoration: BoxDecoration(),
                        child: PhotoView(
                          backgroundDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(18.0),
                            ),
                          ),
                          imageProvider: imageProvider,
                        ),
                      );
                    }
                    return SizedBox();
                  },
                );
              },
              placeholder: (context, _) => SizedBox(
                height: 100,
                width: 100,
                child: Row(
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
              ),
              errorWidget: (_, __, ___) => SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
