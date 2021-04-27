import 'dart:math';

import 'package:LavaDurian/components/DetailOnCard.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class OperationCardProduct extends StatefulWidget {
  @override
  _OperationCardProductState createState() => _OperationCardProductState();
}

class _OperationCardProductState extends State<OperationCardProduct> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final font = Theme.of(context).textTheme;

    return Consumer2<ProductModel, ProductImageModel>(
      builder: (context, productModel, productImageModel, child) {
        if (productModel.products.length != 0) {
          return StaggeredGridView.countBuilder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: 0,
            ),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),

            itemCount: productModel.products.length, //staticData.length,
            itemBuilder: (context, index) {
              final product = productModel.products;

              List listProductImage =
                  productImageModel.getProductImageFromProductId(
                      productId: product[index]['id']);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewProductScreen(
                        productId: productModel.products[index]['id'],
                        hero: '$index',
                        status: productModel.productStatus[
                            productModel.products[index]['status'].toString()],
                        gene: productModel
                            .productGene[product[index]['gene'].toString()],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          if (listProductImage.length != 0) ...{
                            CarouselSlider(
                              options: CarouselOptions(
                                height: size.height * .21,
                                viewportFraction: 1.0,
                                enlargeCenterPage: true,
                                autoPlay:
                                    listProductImage.length > 1 ? true : false,
                                autoPlayInterval: Duration(
                                    seconds: Random()
                                            .nextInt(listProductImage.length) +
                                        5),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                              ),
                              items: listProductImage.map((element) {
                                return Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  // TODO:
                                  // child: Hero(
                                  //   tag: 'image$index',
                                  child: CachedNetworkImage(
                                    filterQuality: FilterQuality.low,
                                    imageUrl: element['image'],
                                    imageBuilder: (_, imageProvider) =>
                                        Container(
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(18.0),
                                          ),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (_, __) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            backgroundColor: kPrimaryColor,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      child: Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  // ),
                                );
                              }).toList(),
                            )
                          } else ...{
                            Container(
                              width: double.infinity,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(18.0)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/images/example.png',
                                  ),
                                ),
                              ),
                            )
                          },
                          Container(
                            margin: EdgeInsets.all(6.8),
                            padding: EdgeInsets.symmetric(horizontal: 6.0),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                "${productModel.productStatus[productModel.products[index]['status'].toString()]}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.8),
                                    child: Hero(
                                      tag: 'gene$index',
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            "${productModel.productGene[product[index]['gene'].toString()]}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.height /
                                                  size.width *
                                                  (font.subtitle1.fontSize /
                                                      2.61),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DetailOnCard(
                                    type: 'จำนวน',
                                    value: product[index]['values'].toString(),
                                    fontSize: size.height /
                                        size.width *
                                        (font.subtitle1.fontSize / 2.58),
                                  ),
                                  DetailOnCard(
                                    type: 'น้ำหนัก',
                                    value: product[index]['weight'].toString(),
                                    fontSize: size.height /
                                        size.width *
                                        (font.subtitle1.fontSize / 2.59),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8.0),
                              child: DetailOnCard(
                                type: 'ราคา',
                                value: product[index]['price'].toString(),
                                fontSize: size.height /
                                    size.width *
                                    (font.subtitle1.fontSize / 2.67),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        // Return Default.
        return Container();
      },
    );
  }
}
