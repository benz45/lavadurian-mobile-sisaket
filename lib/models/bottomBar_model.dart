import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';

enum _SelectedTab { home, order, product, store }

class BottomBarModel with ChangeNotifier {
  _SelectedTab _selectedTab = _SelectedTab.home;
  CarouselController buttonCarouselController = CarouselController();

  // Getther
  get getController => buttonCarouselController;
  get getCurrentSelectedTab => _SelectedTab.values.indexOf(_selectedTab);

  // Setther
  void setSelectedTab(int index) {
    buttonCarouselController.animateToPage(
      index,
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
    notifyListeners();
  }

  void setSelectedTabFromSlider(int index, CarouselPageChangedReason reason) {
    _selectedTab = _SelectedTab.values[index];
    notifyListeners();
  }
}
