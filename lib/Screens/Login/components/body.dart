import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:LavaDurian/Screens/Signup/signup_screen.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:LavaDurian/components/rounded_button.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as Http;

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  Future<void> _login(
      BuildContext context, String email, String password) async {
    Map<String, String> data = {
      'username': email,
      'password': password,
    };

    final response = await Http.post(
        'https://durian-lava.herokuapp.com/api/login',
        body: data);

    final jsonData = json.decode(response.body);

    if (jsonData['token'] != null) {
      String tokenData = '{"token": "${jsonData['token']}"}';
      print(tokenData);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Can not login !!'),
            content:
                Text("Invalid Username or Password !, Please login again."),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';

    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                email = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                if (email != "" && password != "") {
                  _login(context, email.trim(), password.trim());
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
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
