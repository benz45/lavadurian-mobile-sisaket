import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

enum _SelectedTab { home, order, product, store }

class BottomBarModel with ChangeNotifier {
  _SelectedTab _selectedTab = _SelectedTab.home;
  SwiperController _controller = SwiperController();

  // Getther
  get getSelectedTab => _controller.index;
  get getController => _controller;
  get getCurrentSelectedTab => _SelectedTab.values.indexOf(_selectedTab);

  // Setther
  void setSelectedTab(int v) {
    _controller.move(v);
    notifyListeners();
  }

  void setSelectedTabFromSwipper(int v) {
    _selectedTab = _SelectedTab.values[v];
    notifyListeners();
  }
}
