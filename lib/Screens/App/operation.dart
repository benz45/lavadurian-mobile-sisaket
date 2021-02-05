import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:flutter/material.dart';

class OperationPage extends StatefulWidget {
  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lava Durian Online'),
        automaticallyImplyLeading: false,
      ),
      body: Background(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Lava Durian Online"),
            ],
          ),
        ),
      ),
    );
  }
}
