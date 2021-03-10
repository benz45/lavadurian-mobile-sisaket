import 'package:LavaDurian/Screens/CreateProduct/create_product_screen.dart';
import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Operation/components/body.dart' show Body;

// ignore: todo
//TODO: For Test
// import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart' show ViewProductScreen;

class OperationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(), // assign key to Scaffold
      endDrawerEnableOpenDragGesture: false, // THIS WAY IT WILL NOT OPEN
      drawer: NavDrawer(),
      body: Body(),
      // ignore: todo
      //TODO: For Test
      // body: ViewProductScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => CreateProductScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
