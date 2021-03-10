import 'package:flutter/material.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/constants.dart';

import '../../../constants.dart';

class OperationCardProduct extends StatelessWidget {
  const OperationCardProduct({
    Key key,
    @required this.productModel,
    @required this.productGene,
    @required this.productStatus,
  }) : super(key: key);

  final ProductModel productModel;
  final Map<String, String> productGene;
  final Map<String, String> productStatus;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 18.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: MediaQuery.of(context).size.height /
              (MediaQuery.of(context).size.width * 0.96),
          mainAxisSpacing: 16.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final product = productModel.products;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewProductScreen(
                      hero: '$index',
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
                child: Row(
                  children: [
                    Hero(
                        tag: '$index',
                        child: Stack(
                          children: [
                            Container(
                              height: double.infinity,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(18.0)),
                                image: DecorationImage(
                                  fit: BoxFit
                                      .cover, //I assumed you want to occupy the entire space of the card
                                  image: AssetImage(
                                    'assets/images/example.png',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(6.8),
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(7.5),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  "${productStatus[productModel.products[index]['status'].toString()]}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                              ),
                            ),
                            // SizedBox(height: 3.0),
                          ],
                        )),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.8),
                                  child: Text(
                                    "${productGene[product[index]['gene'].toString()]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ),
                                DetailProduct(
                                  type: 'จำนวน',
                                  value: product[index]['values'].toString(),
                                  fontSize: 14.0,
                                ),
                                DetailProduct(
                                  type: 'น้ำหนัก',
                                  value: product[index]['weight'].toString(),
                                  fontSize: 14.0,
                                ),
                              ],
                            ),
                            DetailProduct(
                              type: 'ราคา',
                              value: product[index]['price'].toString(),
                              fontSize: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: productModel.products.length,
        ),
      ),
    );
  }
}

class DetailProduct extends StatelessWidget {
  final String type;
  final String value;
  final double fontSize;
  const DetailProduct({
    Key key,
    @required this.type,
    @required this.value,
    this.fontSize = 14.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$type \t",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: kTextSecondaryColor),
        ),
        Text(
          "$value",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: kPrimaryColor),
        ),
      ],
    );
  }
}
