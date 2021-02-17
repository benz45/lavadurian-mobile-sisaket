import 'package:LavaDurian/components/header_text_signup.dart';
import 'package:LavaDurian/components/social_signup.dart';
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var maskFormatter = new MaskTextInputFormatter(
        mask: '#-####-#####-##-#', filter: {"#": RegExp(r'[0-9]')});

    void _onChange(_) {
      print(maskFormatter.getUnmaskedText());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HeaderTextSignUp(),
        RoundedInputField(
          hintText: "รหัสประจำตัวประชาชน",
          inputFormatters: [
            maskFormatter,
          ],
          keyboardType: TextInputType.number,
          icon: Icons.person_pin_rounded,
          onChanged: _onChange,
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
        // SocialSignUp()
      ],
    );
  }
}
