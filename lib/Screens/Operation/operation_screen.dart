import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Operation/components/body.dart' show Body;

class OperationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(), // assign key to Scaffold
      endDrawerEnableOpenDragGesture: false, // THIS WAY IT WILL NOT OPEN
      drawer: NavDrawer(),
      body: Body(),
    );
  }
}