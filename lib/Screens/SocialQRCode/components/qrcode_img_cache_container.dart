import 'package:LavaDurian/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class QRCodeCachedImageNetwork extends StatelessWidget {
  const QRCodeCachedImageNetwork({
    Key key,
    @required this.imgUrl,
  }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: FilterQuality.low,
      fadeOutCurve: Curves.fastOutSlowIn,
      cacheKey: imgUrl,
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(18.0),
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
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
        )),
      ),
    );
  }
}
