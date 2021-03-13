import 'package:LavaDurian/Screens/EditProduct/components/body.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProductScreen extends StatelessWidget {
  final int productID;
  const EditProductScreen({Key key, @required this.productID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('แก้ไขข้อมูลสินค้า').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: Body(productID: productID),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.delete_outlined),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
