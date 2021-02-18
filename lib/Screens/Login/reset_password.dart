import 'dart:convert';

import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as Http;

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  SettingModel settingModel;
  String email = '';

  Future<void> _resetPassword(String email) async {
    String msg = "Your email is not valid";

    Map<String, dynamic> data = {
      'email': email,
    };

    final response = await Http.post(
        "${settingModel.baseURL}/${settingModel.endPointResetPassword}",
        body: data);

    var jsonData = jsonDecode(response.body);
    if (jsonData['detail'] != null) {
      msg = jsonData['detail'];
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Email has been send !"),
            content: Text("Please, check your email for reset your password."),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("OK"))
            ],
          );
        },
      );
    }

    _btnController.stop();
  }

  @override
  void initState() {
    settingModel = context.read<SettingModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Login Button
    final loginButton = RoundedLoadingButton(
      child: Text(
        "RESET",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      width: MediaQuery.of(context).size.width,
      color: Color(0xFF6F35A5),
      controller: _btnController,
      onPressed: () {
        if (email == "") {
          _btnController.stop();
        } else {
          _resetPassword(email);
        }
      },
    );

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset My Password'),
      ),
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email to Reset Password",
                onChanged: (value) {
                  email = value;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: loginButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
