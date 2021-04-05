import 'dart:convert';

import 'package:LavaDurian/Screens/StoreNoData/store_no_data.dart';
import 'package:LavaDurian/class/file_process.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Signup_ID_Card/signup_id_card_screen.dart';
import 'package:LavaDurian/components/already_have_an_account_acheck.dart';
import 'package:flutter_svg/svg.dart';
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

  // Checkbox State
  bool checkboxValue = false;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
  }

  @override
  Widget build(BuildContext context) {
    final storeSignUp = Provider.of<SignupModel>(context);

    Future<void> _login(BuildContext context) async {
      Map<String, String> data = {
        'username': storeSignUp.getEmail,
        'password': storeSignUp.getPassword,
      };

      final response = await Http.post(
          '${settingModel.baseURL}/${settingModel.endPointLogin}',
          body: data);

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
          // Clear Navigate route
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: StoreNodata(
                    headText: 'ยินดีต้อนรับเข้าสู่ระบบ !',
                  ),
                ),
              ),
              (Route<dynamic> route) => false);
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

    // Get started app Button
    final getstartedButton = RoundedLoadingButton(
        child: Text(
          "เริ่มต้นใช้งาน",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        controller: _btnController,
        width: MediaQuery.of(context).size.width,
        color: kPrimaryColor,
        onPressed: () => _login(context));

    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/undraw_order_confirmed_aaw7.svg",
            width: size.width * 0.6,
          ),
          SizedBox(height: size.height * 0.03),
          Text(
            "ลงทะเบียนสำเร็จ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: checkboxValue,
                onChanged: (_) =>
                    setState(() => checkboxValue = !checkboxValue),
                activeColor: kPrimaryColor,
              ),
              Text('ยอมรับข้อกำหนดและการใช้บริการ'),
              SizedBox(width: size.width * 0.01),
              Text(
                'ข้อกำหนด',
                style: TextStyle(
                    color: kPrimaryColor,
                    decorationColor: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: getstartedButton,
          ),
          SizedBox(height: size.height * 0.01),
          AlreadyHaveAnAccountCheck(
            login: false,
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
    );
  }
}
