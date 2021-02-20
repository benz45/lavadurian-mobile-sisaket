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
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/icons/logo_lava_durian_sisaket_top.svg",
              height: size.height * 0.45,
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
              textColor: kPrimaryColor,
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
