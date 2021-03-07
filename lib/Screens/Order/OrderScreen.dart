import 'package:LavaDurian/Screens/Order/components/body.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('รายการคำสั่งซื้อ').text.color(kTextPrimaryColor).make(),
        leading: Icon(
          Icons.arrow_back_rounded,
          color: kPrimaryColor,
        ),
      ),
      body: Body(),
    );
  }
}
