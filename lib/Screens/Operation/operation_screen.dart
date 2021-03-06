import 'package:LavaDurian/models/drawer_model.dart';

import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LavaDurian/Screens/Operation/components/body.dart' show Body;

class OperationScreen extends StatefulWidget {
  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.watch<DrawerModel>().getDrawerKey, // assign key to Scaffold
      endDrawerEnableOpenDragGesture: false, // THIS WAY IT WILL NOT OPEN
      drawer: NavDrawer(),
      body: Body(),
    );
  }
}
