import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class HeaderTextSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Text(
            "ทุเรียนภูเขาไฟศรีสะเกษ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        Text(
          "สมัครใช้งานเพื่อสร้างร้านค้าและอัพเดทสินค้า",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kTextSecondaryColor,
            fontSize: 16,
          ),
        ),
        SizedBox(height: size.height * 0.03)
      ],
    );
  }
}
