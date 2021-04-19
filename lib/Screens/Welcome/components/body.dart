import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/Screens/Signup_ID_Card/signup_id_card_screen.dart';
import 'package:LavaDurian/Screens/Welcome/components/background.dart';
import 'package:LavaDurian/components/rounded_button.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size.width * .6,
              child: Image(
                image: AssetImage("assets/icons/A_002.png"),
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'ทุเรียนภูเขาไฟศรีสะเกษ',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    'สมัครใช้งานเพื่อสร้างร้านค้าและอัพเดทสินค้าของคุณ',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "เข้าสู่ระบบ",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "ลงทะเบียน",
              color: kPrimaryLightColor,
              textColor: Colors.white,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpIDCardScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
