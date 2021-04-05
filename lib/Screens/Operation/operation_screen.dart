import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:LavaDurian/components/salomon_bottom_bar.dart';
import 'package:LavaDurian/models/bottomBar_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/Screens/Operation/components/body.dart' show Body;
import 'package:provider/provider.dart';

// ignore: todo
//TODO: For Test
// import 'package:LavaDurian/Screens/ViewOrder/view_order_screen.dart'
//     show ViewOrderScreen;
class OperationScreen extends StatefulWidget {
  @override
  _OperationScreenState createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomBarModel>(create: (_) => BottomBarModel()),
        ChangeNotifierProvider<ItemModel>(create: (_) => ItemModel()),
      ],
      child: Scaffold(
        key: GlobalKey(), // assign key to Scaffold
        endDrawerEnableOpenDragGesture: false, // THIS WAY IT WILL NOT OPEN
        drawer: NavDrawer(),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Body(),
            // * Gradient color white bottom
            Positioned(
              child: Container(
                height: 35,
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
        bottomNavigationBar: MySalomonBottomBar(),
      ),
    );
  }
}
