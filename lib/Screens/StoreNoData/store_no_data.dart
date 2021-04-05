import 'package:LavaDurian/Screens/CreateStore/create_store_screen.dart';
import 'package:LavaDurian/components/rounded_button.dart';
import 'package:LavaDurian/constants.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreNodata extends StatelessWidget {
  final String headText;

  StoreNodata({Key key, this.headText = 'ตอนนี้คุณยังไม่มีร้านค้า'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DelayedDisplay(
              delay: Duration(seconds: 1),
              child: SvgPicture.asset(
                "assets/icons/undraw_add_to_cart_vkjp.svg",
                width: size.width * 0.60,
              ),
            ),
            SizedBox(
              height: 26,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 1400),
              child: Text(
                "$headText",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: kTextPrimaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 1600),
              child: Text(
                'กดที่ปุ่ม "สร้างร้านค้า" เพื่อสร้างร้านค้าของคุณ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: kTextSecondaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 2000),
              child: RoundedButton(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateStoreScreen(
                        backArrowButton: false,
                      ),
                    ),
                  );
                },
                text: 'สร้างร้านค้า',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
