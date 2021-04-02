import 'package:LavaDurian/Screens/CreateStore/components/body.dart';
import 'package:flutter/material.dart';

class CreateStoreScreen extends StatelessWidget {
  final bool backArrowButton;
  CreateStoreScreen({this.backArrowButton});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Body(
          backArrowButton: backArrowButton,
        ),
      ),
    );
  }
}
