import 'package:LavaDurian/Screens/CreateProduct/components/body.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateProductScreen extends StatelessWidget {
  final int storeID;
  const CreateProductScreen({Key key, @required this.storeID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('สร้างสินค้า').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: Body(storeID: storeID),
    );
  }
}
