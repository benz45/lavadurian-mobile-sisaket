import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Operation/components/body.dart' show Body;

// ignore: todo
//TODO: For Test
// import 'package:LavaDurian/Screens/ViewOrder/view_order_screen.dart'
//     show ViewOrderScreen;

class OperationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(), // assign key to Scaffold
      endDrawerEnableOpenDragGesture: false, // THIS WAY IT WILL NOT OPEN
      drawer: NavDrawer(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Body(),
          Positioned(
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.0), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
