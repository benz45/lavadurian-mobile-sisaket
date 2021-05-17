import 'package:LavaDurian/Screens/CreateProduct/create_product_screen.dart';
import 'package:LavaDurian/Screens/CreateProductDemo/create_product_demo_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class StoreApproval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer2<StoreModel, ProductModel>(
      builder: (context, storeModel, productModel, child) {
        // * Fillter for product in current store
        var products = productModel.products.where((element) => element['store'] == storeModel.getCurrentIdStore).toList();

        if (products.length == 0) {
          return Container(
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/undraw_add_product.svg",
                  width: size.width * 0.40,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: FlatButton(
                    height: 40,
                    color: kPrimaryColor.withOpacity(0.15),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    splashColor: kPrimaryColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "สร้างสินค้าของคุณ",
                      style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateProductDemoScreen(
                            backArrowButton: true,
                            storeID: storeModel.getCurrentIdStore,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
