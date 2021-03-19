import 'package:LavaDurian/components/DetailOnCard.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    Size size = MediaQuery.of(context).size;
    final font = Theme.of(context).textTheme;

    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.only(
        top: 0,
      ),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: productModel.products.length, //staticData.length,
      itemBuilder: (context, index) {
        final product = productModel.products;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewProductScreen(
                  hero: '$index',
                  status: productStatus[
                      productModel.products[index]['status'].toString()],
                  gene: productGene[product[index]['gene'].toString()],
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
                    Hero(
                      tag: 'image$index',
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(18.0)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/example.png',
                            ),
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
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "${productStatus[productModel.products[index]['status'].toString()]}",
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
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
                                      "${productGene[product[index]['gene'].toString()]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height /
                                            size.width *
                                            (font.subtitle1.fontSize / 2.61),
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
}
