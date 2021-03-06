import 'dart:convert';

import 'package:LavaDurian/Screens/Login/reset_password.dart';
import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/class/file_process.dart';
import 'package:LavaDurian/components/reset_password.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:LavaDurian/Screens/Signup_ID_Card/signup_id_card_screen.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/rounded_password_field.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  SettingModel settingModel;

  String email = '';
  String password = '';

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  Future<void> _login(BuildContext context, String email, String password) async {
    Map<String, String> data = {
      'username': email,
      'password': password,
    };

    final response = await Http.post('${settingModel.baseURL}/${settingModel.endPointLogin}', body: data);

    final jsonData = json.decode(response.body);

    if (jsonData['token'] != null) {
      String tokenData = '{"token": "${jsonData['token']}"}';

      // Set value to setting model
      settingModel.value = jsonData;

      // Write token to setting file
      try {
        FileProcess fileProcess = FileProcess('setting.json');
        fileProcess.writeData(tokenData);
        _btnController.success();
        Navigator.push(context, MaterialPageRoute(builder: (context) => OperationScreen()));
      } catch (e) {
        print(e);
      }
    } else {
      _btnController.stop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('???????????????????????????????????????????????????????????? !!'),
            content: Text("?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????."),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
  }

  @override
  Widget build(BuildContext context) {
    // Login Button
    final loginButton = RoundedLoadingButton(
      child: Text(
        "?????????????????????????????????",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        if (email != "" && password != "") {
          _login(context, email.trim(), password.trim());
        } else {
          _btnController.stop();
        }
      },
    );

    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: size.width * .8,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    '??????????????????????????????????????????????????????????????????',
                    style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.bold),
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
                    '????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                RoundedInputField(
                  hintText: "???????????????????????????/???????????????",
                  icon: Icons.person,
                  onChanged: (value) {
                    email = value;
                  },
                ),
                RoundedPasswordField(
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: size.height * 0.009),
                loginButton,
                SizedBox(height: size.height * 0.03),
                ResetPasswordCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ResetPassword();
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.01),
                AlreadyHaveAnAccountCheck(
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
        ),
      ),
    );
  }
}
