import 'dart:async';
import 'dart:convert';

import 'package:LavaDurian/Screens/Signup_Account_Info/signup_account_info_screen.dart';
import 'package:LavaDurian/components/btnRoundedLoadingButton.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/checkCitizenId_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var data = Map<String, String>();
  final regExpEmail = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final regExpPassword = r"^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$";
  List<TextInputFormatter> limitingTextInput = [LengthLimitingTextInputFormatter(250)];

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  Widget build(BuildContext context) {
    final storeSignup = Provider.of<SignupModel>(context);
    final storeApi = Provider.of<SettingModel>(context);
    Size size = MediaQuery.of(context).size;

    void _onChange({String value, String index}) {
      _btnController.reset();
      setState(() => data[index] = value);
    }

    Future _onSubmit() async {
      try {
        bool result = await validateData(context, storeApi);
        if (result) {
          storeSignup.setEmail = data['email'];
          storeSignup.setPassword = data['password'];
          _btnController.success();
          Timer(Duration(milliseconds: 350), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignUpAccountInfoScreen();
                },
              ),
            );
          });
        }
      } catch (err) {
        throw err;
      }
    }

    return Container(
      constraints: BoxConstraints.expand(),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width * .8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    "ทุเรียนภูเขาไฟศรีสะเกษ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                Text(
                  "สมัครใช้งานเพื่อสร้างร้านค้าและอัพเดทสินค้า",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kTextSecondaryColor,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                RoundedInputField(
                  hintText: "อีเมล",
                  icon: Icons.email,
                  onChanged: (v) => _onChange(value: v, index: 'email'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: limitingTextInput,
                ),
                RoundedInputField(
                  hintText: "รหัสผ่าน ( 8 ตัวอักษรขึ้นไป )",
                  icon: Icons.vpn_key_outlined,
                  onChanged: (v) => _onChange(value: v, index: 'password'),
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  inputFormatters: limitingTextInput,
                ),
                RoundedInputField(
                  hintText: "ยืนยันรหัสผ่าน",
                  icon: Icons.vpn_key,
                  onChanged: (v) => _onChange(value: v, index: 'cPassword'),
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  inputFormatters: limitingTextInput,
                ),
                SizedBox(height: size.height * 0.01),
                BtnRoundedLoadingButton(
                  text: 'ถัดไป',
                  controller: _btnController,
                  onPressed: () => _onSubmit(),
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
            ),
          ),
        ),
      ),
    );
  }

  Future validateData(BuildContext context, SettingModel api) async {
    if (data['email']?.length == null || data['password']?.length == null || data['cPassword']?.length == null) {
      showSnackBar(context, 'กรุญากรอกข้อมูลให้ครบถ้วน');
      _btnController.reset();
    } else {
      bool emailValid = RegExp(regExpEmail).hasMatch(data['email']);
      bool passValid = RegExp(regExpPassword).hasMatch(data['password']);

      if (!emailValid) {
        showSnackBar(context, 'กรุญากรอกอีเมลให้ถูกต้อง');
        _btnController.reset();
        return false;
      }

      if (data['password'].length < 8) {
        showSnackBar(context, 'รหัสควรมากกว่า 8 ตัวอักษร');
        _btnController.reset();
        return false;
      }

      if (data['password'] != data['cPassword']) {
        showSnackBar(context, 'รหัสผ่านไม่ตรงกัน');
        _btnController.reset();
        return false;
      }

      if (!passValid) {
        showSnackBar(context, 'รหัสผ่านควรมีตัวพิมพ์ใหญ่, ตัวพิมพ์เล็ก อย่างละ 1 ตัวอักษร');
        _btnController.reset();
        return false;
      }

      if (emailValid && passValid) {
        final response = await http.post(
          Uri.parse('${api.baseURL}/${api.endPointCheckEmail}'),
          body: {
            'email': data['email'],
          },
        );

        if (response.statusCode == 200) {
          final result = CheckInfo.fromJson(jsonDecode(response.body));

          if (result.status) {
            _btnController.reset();
            showSnackBar(context, 'อีเมลนี้มีการลงทะเบียนไว้แล้ว');
            return false;
          } else {
            _btnController.success();
            return true;
          }
        } else {
          _btnController.reset();
          showSnackBar(context, 'เกิดข้อผิดพลาด ${response.statusCode}');
          return false;
        }
      }
    }
  }
}
