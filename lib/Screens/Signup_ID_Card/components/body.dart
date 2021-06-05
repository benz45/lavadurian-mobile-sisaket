import 'dart:async';
import 'dart:convert';

import 'package:LavaDurian/Screens/Signup_Account/signup_account_screen.dart';
import 'package:LavaDurian/components/header_text_signup.dart';
import 'package:LavaDurian/components/btnRoundedLoadingButton.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/models/checkCitizenId_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;

class Body extends StatelessWidget {
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final store = Provider.of<SignupModel>(context);
    final api = Provider.of<SettingModel>(context);

    var maskFormatter = MaskTextInputFormatter(mask: '#-####-#####-##-#', filter: {"#": RegExp(r'[0-9]')});

    Future _onSubmit(BuildContext context) async {
      try {
        FocusManager.instance.primaryFocus.unfocus();
        /*
        We have to choice for user to fill up Citizen ID
        no.1 : Fill up
        no.2 : Skip with out fill up
        */
        if (maskFormatter.getUnmaskedText().length > 0) {
          if (maskFormatter.getUnmaskedText().length != 13) {
            showSnackBar(context, 'เลขบัตรประชาชนไม่ถูกต้อง');
            _btnController.stop();
          }
          if (maskFormatter.getUnmaskedText().length == 13) {
            final response = await http.post(
              Uri.parse('${api.baseURL}/${api.endPointCheckCitizenId}'),
              body: {
                'citizenid': maskFormatter.getUnmaskedText(),
              },
            );

            if (response.statusCode == 200) {
              final result = CheckInfo.fromJson(jsonDecode(response.body));
              if (result.status) {
                showSnackBar(context, 'เลขบัตรประชาชนถูกลงทะเบียนแล้ว');
                _btnController.stop();
              } else {
                store.setCitizenid = maskFormatter.getUnmaskedText();
                _btnController.success();
                Timer(Duration(milliseconds: 350), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpAccountScreen();
                      },
                    ),
                  );
                });
              }
            }
          }
        } else {
          showSnackBar(context, 'ไม่ประสงค์จะกรอกหมายเลขบัตรประจำตัว ?');
          store.setCitizenid = "";
          _btnController.success();
          Timer(Duration(milliseconds: 3600), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignUpAccountScreen();
                },
              ),
            );
          });
        }
      } catch (err) {
        throw (err);
      }
      // Validation ID Card.
    }

    return Center(
      child: Container(
        width: size.width * .8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderTextSignUp(),
            RoundedInputField(
              hintText: "รหัสประจำตัวประชาชน (ข้ามได้)",
              inputFormatters: [
                maskFormatter,
              ],
              keyboardType: TextInputType.number,
              icon: Icons.person_search,
              onSubmitted: (_) => _onSubmit(context),
            ),
            SizedBox(height: size.height * 0.01),
            BtnRoundedLoadingButton(
              text: 'ถัดไป',
              controller: _btnController,
              onPressed: () => _onSubmit(context),
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
    );
  }
}
