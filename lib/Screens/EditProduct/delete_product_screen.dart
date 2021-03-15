import 'package:LavaDurian/Screens/EditProduct/components/body_delete.dart';
import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class DeleteProductScreen extends StatelessWidget {
  final int productID;
  const DeleteProductScreen({Key key, this.productID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductModel productModel = context.read<ProductModel>();

    List<Map<String, dynamic>> products = productModel.products;
    Map<String, dynamic> product;

    if (products != null) {
      product = products.firstWhere((element) => element['id'] == productID);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('ลบข้อมูลสินค้า').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewStoreScreen(product['store']))),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: BodyDelete(productID: productID),
    );
  }
}
