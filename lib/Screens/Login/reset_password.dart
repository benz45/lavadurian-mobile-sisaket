import 'dart:convert';

import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/Screens/Signup_Account/components/background.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/constants.dart';
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
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  SettingModel settingModel;
  String email = '';

  Future<void> _resetPassword(String email) async {
    String msg = "Your email is not valid";

    Map<String, dynamic> data = {
      'email': email,
    };

    final response = await Http.post(Uri.parse("${settingModel.baseURL}/${settingModel.endPointResetPassword}"), body: data);

    var jsonData = jsonDecode(response.body);
    if (jsonData['detail'] != null) {
      msg = jsonData['detail'];
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Email has been send !"),
            content: Text("$msg"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(""),
      ),
      body: Background(
        child: Center(
          child: Container(
            width: size.width * .8,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/undraw_inbox_cleanup_w2ur.svg",
                  width: size.width * 0.45,
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  'เปลี่ยนรหัสผ่าน',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: textTheme.headline6.fontSize,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'หากต้องการเปลี่ยนรหัสผ่าน กรุณากรอกอีเมลที่ใช้ทำการสมัครเข้าใช้งานระบบ',
                  style: TextStyle(
                    color: kTextSecondaryColor,
                    fontSize: textTheme.subtitle1.fontSize,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                RoundedInputField(
                  icon: Icons.mail,
                  hintText: "อีเมลสำหรับเปลี่ยนรหัสผ่าน",
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                RoundedLoadingButton(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "เปลี่ยนรหัสผ่าน",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  // width: MediaQuery.of(context).size.width,
                  color: kPrimaryColor,
                  controller: _btnController,
                  onPressed: () {
                    if (email == "") {
                      _btnController.stop();
                    } else {
                      _resetPassword(email);
                    }
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
