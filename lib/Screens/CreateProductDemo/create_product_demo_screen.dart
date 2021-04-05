import 'package:LavaDurian/Screens/CreateProductDemo/components/body.dart';
import 'package:flutter/material.dart';

class CreateProductDemoScreen extends StatelessWidget {
  final bool backArrowButton;
  final int storeID;
  CreateProductDemoScreen({this.backArrowButton, @required this.storeID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Body(
          storeID: storeID,
          backArrowButton: backArrowButton,
        ),
      ),
    );
  }
}
