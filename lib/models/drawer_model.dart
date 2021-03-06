import 'package:flutter/material.dart';

class DrawerModel with ChangeNotifier {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  // Getters
  get getDrawerKey => _drawerKey;

  // Setters
  void setOpenDrawer() {
    _drawerKey.currentState.openDrawer();
    notifyListeners();
  }
}
