import 'dart:async';
import 'dart:convert';
import 'package:LavaDurian/Screens/Register_Success/register_success_screen.dart';
import 'package:LavaDurian/components/btnRoundedLoadingButton.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Mask Formater Phone Number
  var maskFormatter = MaskTextInputFormatter(mask: '###-###-####', filter: {"#": RegExp(r'[0-9]')});

  // Checkbox State
  bool checkboxValue = true;

  // Input  Formater Limit 250
  List<TextInputFormatter> limitingTextInput = [LengthLimitingTextInputFormatter(250)];

  // Controller Button
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  Widget build(BuildContext context) {
    // Store Provider
    final storeSignup = Provider.of<SignupModel>(context);
    final storeApi = Provider.of<SettingModel>(context);
    Size size = MediaQuery.of(context).size;

    // On Event Checkbox && Set Provider tradertype
    void _onChangedCheckbox(_) {
      setState(() {
        checkboxValue = !checkboxValue;
        if (checkboxValue)
          storeSignup.setTradertype = '0';
        else
          storeSignup.setTradertype = '1';
      });
    }

    // On Sumit
    Future _onSubmit() async {
      try {
        bool validate(v) => v != null || v != '' ? true : false;

        if (validate(storeSignup.getFirstName) &&
            validate(storeSignup.getLastName) &&
            validate(storeSignup.getPhoneNumber) &&
            validate(storeSignup.getTradername) &&
            validate(storeSignup.getTradertype)) {
          if (storeSignup.getPhoneNumber.split('-').join().length < 10) {
            _btnController.reset();
            showSnackBar(context, 'กรุณากรอกหมายเลขโทรศัพท์ให้ถูกต้อง');
            return;
          }

          final response = await http.post(
            Uri.parse('${storeApi.baseURL}/${storeApi.endPointRegis}'),
            body: <String, String>{
              'username': storeSignup.getEmail,
              'password': storeSignup.getPassword,
              'email': storeSignup.getEmail,
              'first_name': storeSignup.getFirstName,
              'last_name': storeSignup.getLastName,
              'citizenid': storeSignup.getCitizenid,
              'tradertype': storeSignup.getTradertype,
              'tradername': storeSignup.getTradername,
              'phone': storeSignup.getPhoneNumber,
            },
          );
          if (response.statusCode == 200) {
            final result = ResponseSignupModel.fromJson(jsonDecode(response.body));

            if (result.status) {
              _btnController.success();
              Timer(Duration(milliseconds: 350), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RegisterSuccessScreen();
                    },
                  ),
                );
              });
            } else {
              _btnController.reset();
              showSnackBar(context, 'เกิดข้อผิดพลาด status ${result.status}');
            }
          } else {
            _btnController.reset();
            showSnackBar(context, 'เกิดข้อผิดพลาด response ${response.statusCode}');
          }
        } else {
          _btnController.reset();
          showSnackBar(context, 'กรุณากรอกข้อมูลให้ครบถ้วน');
          return;
        }
      } catch (err) {
        throw err;
      }
    }

    return Center(
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
                "สมัครใช้งานเพื่อสร้างร้านค้าและอัพเดทสินค้าของคุณ",
                style: TextStyle(fontWeight: FontWeight.bold, color: kTextSecondaryColor),
              ),
              SizedBox(height: size.height * 0.03),

              RoundedInputField(
                hintText: "ชื่อ",
                icon: Icons.title,
                onChanged: (v) => storeSignup.setFirstName = v,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: limitingTextInput,
              ),
              RoundedInputField(
                hintText: "นามสกุล",
                icon: Icons.title,
                onChanged: (v) => storeSignup.setLastName = v,
                textInputAction: TextInputAction.next,
                inputFormatters: limitingTextInput,
              ),
              RoundedInputField(
                hintText: "หมายเลขโทรศัพท์",
                icon: Icons.phone_iphone,
                onChanged: (v) => storeSignup.setPhoneNumber = v,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  maskFormatter,
                ],
              ),
              // RoundedInputField(
              //   hintText: "ชื่อร้าน",
              //   icon: Icons.shopping_cart_outlined,
              //   onChanged: (v) => storeSignup.setTradername = v,
              //   textInputAction: TextInputAction.next,
              //   inputFormatters: limitingTextInput,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: checkboxValue,
                    onChanged: _onChangedCheckbox,
                    activeColor: kPrimaryColor,
                  ),
                  Text(storeSignup.tTrader['0']),
                  SizedBox(
                    width: 8.0,
                  ),
                  Checkbox(
                    value: !checkboxValue,
                    onChanged: _onChangedCheckbox,
                    activeColor: kPrimaryColor,
                  ),
                  Text(storeSignup.tTrader['1']),
                ],
              ),
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
    );
  }
}
