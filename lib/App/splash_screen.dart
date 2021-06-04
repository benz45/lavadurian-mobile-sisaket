import 'dart:async';
import 'dart:convert';
import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/Screens/Welcome/components/background.dart';
import 'package:LavaDurian/Screens/Welcome/welcome_screen.dart';
import 'package:LavaDurian/class/file_process.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SettingModel settingModel;
  String setting;

  Future<String> _getSetting() async {
    FileProcess fileProcess = FileProcess('setting.json');

    Future.delayed(Duration(seconds: 2), () async {
      setting = await fileProcess.readData();
      await _checkAuthentication();
    });

    return setting;
  }

  Future<void> _checkAuthentication() async {
    if (setting == 'fail' || setting == '{}') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } else {
      settingModel.value = jsonDecode(setting);
      // Clear Navigate route
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OperationScreen()), (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: FutureBuilder(
                  future: _getSetting(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container();
                    } else {
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Image(
                              image: AssetImage("assets/icons/A_002.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              'ทุเรียนภูเขาไฟศรีสะเกษ',
                              style: TextStyle(color: kPrimaryColor, fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
