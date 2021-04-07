import 'package:LavaDurian/Screens/AllStatusOrder/components/body.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class AllStatusOrderScreen extends StatelessWidget {
  final storeID;
  const AllStatusOrderScreen({Key key, this.storeID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title:
            Text('สถานะคำสั่งซื้อทั้งหมด').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Body(storeID: this.storeID),
      ),
    );
  }
}
