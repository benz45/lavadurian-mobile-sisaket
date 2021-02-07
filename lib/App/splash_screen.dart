import 'dart:async';
import 'dart:convert';
import 'package:LavaDurian/app/operation.dart';
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
  String setting;

  Future<String> _getSetting() async {
    FileProcess fileProcess = FileProcess('setting.json');
    setting = await fileProcess.readData();
    return setting;
  }

  Future<void> _checkAuthentication() async {
    print(setting);
    if (setting == 'fail' || setting == '{}') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OperationPage()),
      );
    }
  }

  Future<void> startTime() async {
    var duration = new Duration(seconds: 1);
    return new Timer(duration, _checkAuthentication);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, setting, child) => Scaffold(
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
                      setting.value = jsonDecode(snapshot.data);
                      startTime();
                      return Column(
                        children: [
                          CircularProgressIndicator(),
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
      ),
    );
  }
}
