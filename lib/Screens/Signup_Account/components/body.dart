import 'package:LavaDurian/components/text_field_container.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/Screens/Signup_ID_Card/components/background.dart';
import 'package:LavaDurian/Screens/Signup_ID_Card/components/or_divider.dart';
import 'package:LavaDurian/Screens/Signup_ID_Card/components/social_icon.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:LavaDurian/components/rounded_button.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/rounded_password_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Body extends StatelessWidget {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void _onChange(value) {
      print(value);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Text(
            "ทุเรียนภูเขาไฟศรีสะเกษ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        Text(
          "สมัครใช้งานเพื่อสร้างร้านค้าและอัพเดทสินค้าของคุณ",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: kTextSecondaryColor),
        ),
        SizedBox(height: size.height * 0.03),

        RoundedInputField(
          hintText: "อีเมล",
          icon: Icons.email,
          onChanged: _onChange,
          textInputAction: TextInputAction.next,
        ),
        RoundedInputField(
          hintText: "รหัสผ่าน",
          icon: Icons.vpn_key_outlined,
          onChanged: _onChange,
          textInputAction: TextInputAction.next,
        ),
        RoundedInputField(
          hintText: "ยืนยันรหัสผ่าน",
          icon: Icons.vpn_key,
          onChanged: _onChange,
          textInputAction: TextInputAction.done,
        ),
        RoundedButton(
          text: "ถัดไป",
          press: () {},
        ),
        SizedBox(height: size.height * 0.03),
        AlreadyHaveAnAccountCheck(
          login: false,
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
        // ignore: todo
        // TODO:(Next Feature) Social Sign Up.
        // OrDivider(),
        //  Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     SocalIcon(
        //       iconSrc: "assets/icons/facebook.svg",
        //       press: () {},
        //     ),
        //     SocalIcon(
        //       iconSrc: "assets/icons/twitter.svg",
        //       press: () {},
        //     ),
        //     SocalIcon(
        //       iconSrc: "assets/icons/google-plus.svg",
        //       press: () {},
        //     ),
        //   ],
        // )
      ],
    );
  }
}
