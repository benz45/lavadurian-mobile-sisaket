import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreWaitApproval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/undraw_confirmation.svg",
            width: size.width * 0.40,
          ),
          SizedBox(
            height: 16.0,
          ),
          Center(
            child: Text(
              'กำลังรอการ "อนุมัติร้านค้า" จากผู้ดูแลระบบ',
              style: TextStyle(
                  color: kTextSecondaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
