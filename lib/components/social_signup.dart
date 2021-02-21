import 'package:LavaDurian/Screens/Signup_Account/components/or_divider.dart';
import 'package:LavaDurian/Screens/Signup_Account/components/social_icon.dart';
import 'package:flutter/material.dart';

class SocialSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}
