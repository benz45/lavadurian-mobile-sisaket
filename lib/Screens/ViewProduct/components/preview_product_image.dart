import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PreviewProductImage extends StatefulWidget {
  const PreviewProductImage({
    Key key,
    @required this.productId,
  }) : super(key: key);

  final int productId;

  @override
  _PreviewProductImageState createState() => _PreviewProductImageState();
}

class _PreviewProductImageState extends State<PreviewProductImage> {
  @override
  void initState() {
    productId = widget.productId;
    super.initState();
  }

  // index for AnimatedSmoothIndicator
  int currentIndex = 0;

  int productId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    ProductImageModel _productImageModel =
        Provider.of<ProductImageModel>(context);

    List listProductImage =
        _productImageModel.getProductImageFromProductId(productId: productId);

    return Stack(
      children: [
        // * Slide image
        CarouselSlider(
          options: CarouselOptions(
            height: size.height * .4,
            viewportFraction: 1.0,
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: _productImageModel
              .getProductImageFromProductId(productId: productId)
              .map<Widget>((item) {
            return GridTile(
              child: CachedNetworkImage(
                imageUrl: item['image'],
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
                        'เกิดข้อผิดพลาดในการดาวน์โหลดรูปภาพ',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // * Indicator select image
        Positioned(
          width: size.width,
          bottom: size.height * 0.035,
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: listProductImage.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.white,
                dotColor: kTextSecondaryColor.withOpacity(0.2),
                dotHeight: size.height * 0.0135,
                dotWidth: size.height * 0.0135,
                expansionFactor: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
