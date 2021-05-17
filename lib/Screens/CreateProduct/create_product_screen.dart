import 'package:LavaDurian/Screens/CreateProduct/components/body.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class CreateProductDemoScreen extends StatelessWidget {
  final bool backArrowButton;
  final int storeID;
  CreateProductDemoScreen({this.backArrowButton, @required this.storeID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(""),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Body(
          storeID: storeID,
          backArrowButton: backArrowButton,
        ),
      ),
    );
  }
}
