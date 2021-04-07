import 'package:LavaDurian/Screens/ViewOrder/components/build_subtext.dart';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewOrderDetailProduct extends StatelessWidget {
  final int productId;
  const ViewOrderDetailProduct({
    Key key,
    @required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverPadding(
      padding: const EdgeInsets.only(top: 20.0),
      sliver: Consumer<ProductModel>(
        builder: (_, _productModel, c) {
          // Filter product id on the mapOrderItems id.
          final Map mapProduct = _productModel.products
              .firstWhere((e) => e['id'] == productId, orElse: () => {});

          // Filter product gene.
          final String mapProductGene =
              _productModel.productGene['${mapProduct['gene']}'];

          return SliverToBoxAdapter(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.04),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: size.width * 0.9,
                child: Column(
                  children: [
                    // ! Header title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'รายละเอียดสินค้า',
                          style: TextStyle(
                              color: kTextSecondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .fontSize),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewProductScreen(
                                  productId: mapProduct['id'],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'ไปยังสินค้า',
                                style: TextStyle(
                                    color: kTextSecondaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .fontSize),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: kTextSecondaryColor,
                                size: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .fontSize,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    // ! Image product
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewProductScreen(
                              productId: mapProduct['id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: size.height * 0.09,
                        width: size.height * 0.09,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          image: DecorationImage(
                            fit: BoxFit
                                .cover, //I assumed you want to occupy the entire space of the card
                            image: AssetImage(
                              'assets/images/example.png',
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ! Content
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // * Product name
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                '$mapProductGene',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kTextPrimaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .fontSize),
                              ),
                            ),
                          ),
                          BuildSubText(
                            leading: 'เกรดทุเรียน',
                            text:
                                '${_productModel.productGrade['${mapProduct['grade']}']}',
                          ),
                          BuildSubText(
                            leading: 'น้ำหนัก (กก.)',
                            text: '${mapProduct['weight']} กก.',
                          ),
                          BuildSubText(
                            leading: 'ราคา (ต่อ/กก.)',
                            text: '${mapProduct['price']} บาท',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
