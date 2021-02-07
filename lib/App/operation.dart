import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationPage extends StatefulWidget {
  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingModel>(
      builder: (context, setting, child) => Scaffold(
        appBar: AppBar(
          title: Text('Lava Durian Online'),
          // automaticallyImplyLeading: false,
        ),
        drawer: NavDrawer(),
        body: Background(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${setting.value}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
