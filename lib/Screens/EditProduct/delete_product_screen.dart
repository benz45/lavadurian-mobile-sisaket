import 'package:LavaDurian/Screens/EditProduct/components/body_delete.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DeleteProductScreen extends StatelessWidget {
  final int productID;
  const DeleteProductScreen({Key key, this.productID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('ลบข้อมูลสินค้า').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: BodyDelete(productID: productID),
    );
  }
}
