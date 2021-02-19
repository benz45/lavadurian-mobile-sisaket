import 'dart:convert';

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
  final regExpEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final regExpPassword = r"^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$";
  List<TextInputFormatter> limitingTextInput = [
    LengthLimitingTextInputFormatter(250)
  ];

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Widget build(BuildContext context) {
    final store = Provider.of<SignupModel>(context);
    final api = Provider.of<SettingModel>(context);
    Size size = MediaQuery.of(context).size;

    void _onChange({String value, String index}) {
      _btnController.reset();
      setState(() => data[index] = value);
    }

    Future _onSubmit() async {
      try {
        if (data['email']?.length == null ||
            data['password']?.length == null ||
            data['cPassword']?.length == null) {
          _showSnackBar(context, 'กรุญากรอกข้อมูลให้ครบถ้วน');
          _btnController.error();
        } else {
          bool emailValid = RegExp(regExpEmail).hasMatch(data['email']);
          bool passValid = RegExp(regExpPassword).hasMatch(data['password']);

          if (!emailValid) {
            _showSnackBar(context, 'กรุญากรอกอีเมลให้ถูกต้อง');
            _btnController.error();
            return;
          }

          if (data['password'].length < 6) {
            _showSnackBar(context, 'รหัสควรมากกว่า 6 ตัวอักษร');
            _btnController.error();
            return;
          }

          if (data['password'] != data['cPassword']) {
            _showSnackBar(context, 'รหัสผ่านไม่ตรงกัน');
            _btnController.error();
            return;
          }

          if (!passValid) {
            _showSnackBar(context,
                'รหัสผ่านควรมีตัวพิมพ์ใหญ่, ตัวพิมพ์เล็ก อย่างละ 1 ตัวอักษร');
            _btnController.error();
            return;
          }

          if (emailValid && passValid) {
            final response = await http
                .post('${api.baseURL}/${api.endPointCheckEmail}', body: {
              'email': data['email'],
            });

            if (response.statusCode == 200) {
              final result = CheckInfo.fromJson(jsonDecode(response.body));

              if (result.status) {
                _btnController.stop();
                _showSnackBar(context, 'อีเมลนี้มีการลงทะเบียนไว้แล้ว');
              } else {
                // ignore: todo
                // TODO: (Next Version) ;
                _btnController.success();
              }
            }
          }
        }
      } catch (err) {
        throw err;
      }
    }

    final Widget _onSubmitButton = RoundedLoadingButton(
      child: Text(
        "ถัดไป",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () => _onSubmit(),
    );

    return Container(
      constraints: BoxConstraints.expand(),
      child: Center(
        child: SingleChildScrollView(
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
                "สมัครใช้งานเพื่อสร้างร้านค้าและอัพเดทสินค้าของคุณ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kTextSecondaryColor),
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
                hintText: "รหัสผ่าน ( มากกว่า 6 ตัวอักษร )",
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: _onSubmitButton,
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
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
