import 'dart:async';
import 'dart:convert';
import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/Screens/Welcome/welcome_screen.dart';
import 'package:LavaDurian/class/file_process.dart';
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
    setting = await fileProcess.readData();
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
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OperationScreen()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> startTime() async {
    var duration = new Duration(seconds: 1);
    return new Timer(duration, _checkAuthentication);
  }

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('WELCOME TO LAVADURIAN ONLINE'),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: FutureBuilder(
                future: _getSetting(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    startTime();
                    return Column(
                      children: [
                        // CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
