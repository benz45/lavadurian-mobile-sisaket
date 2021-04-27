import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/check_transfer_order_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:intl/intl.dart';
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
              SizedBox(
                width: 8,
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
            if (snap.hasData) {
              CheckTransferOrderModel data = snap?.data;

              return Column(
                children: [
                  if (data != null)
                    CachedNetworkImage(
                      filterQuality: FilterQuality.high,
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
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HeroPhotoViewRouteWrapper(
                                        tag: "transfer${data.transfer.id}",
                                        imageProvider: imageProvider,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: _size.width,
                                  height: _size.height * .5,
                                  decoration: BoxDecoration(),
                                  child: Hero(
                                    tag: "transfer${data.transfer.id}",
                                    child: PhotoView(
                                      filterQuality: FilterQuality.high,
                                      backgroundDecoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(18.0),
                                        ),
                                      ),
                                      customSize: _size * .5,
                                      imageProvider: imageProvider,
                                    ),
                                  ),
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
                    ),
                  SizedBox(
                    height: 26,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'ชำระไปที่บัญชี',
                                  style: TextStyle(
                                    height: 1.4,
                                    color: kTextSecondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontSize,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '${data.transfer.bookbank}',
                                  style: TextStyle(
                                    height: 1.4,
                                    color: kTextSecondaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontSize,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                child: Text(
                                  "ชำระเมื่อเวลา",
                                  style: TextStyle(
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                    color: kTextSecondaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontSize,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${DateFormat('dd-MM-yyyy เวลา HH:mm น.').format(DateTime.parse("${data.transfer.transferDate}").toLocal())}",
                                  style: TextStyle(
                                    height: 1.4,
                                    color: kTextSecondaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontSize,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                child: Text(
                                  "คำอธิบายเพิ่มเติม",
                                  style: TextStyle(
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                    color: kTextSecondaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontSize,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '${data.transfer.note.length != 0 ? data.transfer.note : "-"}',
                                  style: TextStyle(
                                    height: 1.4,
                                    color: kTextSecondaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    @required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.tag,
  });

  final ImageProvider imageProvider;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String tag;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoView(
            imageProvider: imageProvider,
            backgroundDecoration: backgroundDecoration,
            minScale: minScale,
            maxScale: maxScale,
            heroAttributes: PhotoViewHeroAttributes(tag: tag),
          ),
        ),
        Positioned(
          top: size.width * .07 + padding.top,
          left: size.width * .07,
          child: ClipOval(
            child: Material(
              color: Colors.white.withOpacity(0.2),
              child: InkWell(
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_rounded),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
