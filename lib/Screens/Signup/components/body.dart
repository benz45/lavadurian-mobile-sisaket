import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/Screens/Signup/components/background.dart';
import 'package:LavaDurian/Screens/Signup/components/or_divider.dart';
import 'package:LavaDurian/Screens/Signup/components/social_icon.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:LavaDurian/components/rounded_button.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "First Name",
              icon: Icons.person,
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Last Name",
              icon: Icons.person,
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Citizen ID",
              icon: Icons.person_pin_rounded,
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Your Email",
              icon: Icons.email,
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Store Name",
              icon: Icons.store_outlined,
              onChanged: (value) {},
            ),
            // DropdownButton(items: [],),
            RoundedInputField(
              hintText: "Phone Number",
              icon: Icons.phone,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
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
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
