import 'dart:convert';

import 'package:LavaDurian/class/file_process.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:LavaDurian/Screens/Signup/signup_screen.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:LavaDurian/components/rounded_button.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Body extends StatelessWidget {
  // const Body({
  //   Key key,
  // }) : super(key: key);
  String email = '';
  String password = '';

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

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

      // Write token to setting file
      try {
        FileProcess fileProcess = FileProcess('setting.json');
        fileProcess.writeData(tokenData);
        print("Login success");
        _btnController.success();
      } catch (e) {
        print(e);
      }
    } else {
      _btnController.stop();
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
    // Login Button
    final loginButton = RoundedLoadingButton(
      child: Text(
        "LOGIN",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFF6F35A5),
      onPressed: () {
        if (email != "" && password != "") {
          _login(context, email.trim(), password.trim());
        }
      },
    );

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: loginButton,
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
