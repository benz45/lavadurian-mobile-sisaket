import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

enum _SelectedTab { home, order, search, store }

class MySalomonBottomBar extends StatefulWidget {
  @override
  _MySalomonBottomBar createState() => _MySalomonBottomBar();
}

class _MySalomonBottomBar extends State<MySalomonBottomBar> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SalomonBottomBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _handleIndexChanged,
        items: [
          SalomonBottomBarItem(
            activeIcon: Icon(
              Icons.home,
              color: kPrimaryColor,
            ),
            icon: Icon(
              Icons.home,
              color: kTextSecondaryColor,
            ),
            title: Text(
              "หน้าหลัก",
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
            ),
            selectedColor: kPrimaryColor,
          ),
          SalomonBottomBarItem(
            activeIcon: Icon(
              Icons.list_alt_rounded,
              color: kPrimaryColor,
            ),
            icon: Icon(
              Icons.list_alt_rounded,
              color: kTextSecondaryColor,
            ),
            title: Text(
              "รายการสั่งซื้อ",
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
            ),
            selectedColor: kPrimaryColor,
          ),
          SalomonBottomBarItem(
            activeIcon: Icon(
              Icons.shopping_basket_rounded,
              color: kPrimaryColor,
            ),
            icon: Icon(
              Icons.shopping_basket_rounded,
              color: kTextSecondaryColor,
            ),
            title: Text(
              "สินค้า",
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
            ),
            selectedColor: kPrimaryColor,
          ),
          SalomonBottomBarItem(
            activeIcon: Icon(
              Icons.storefront,
              color: kPrimaryColor,
            ),
            icon: Icon(
              Icons.storefront,
              color: kTextSecondaryColor,
            ),
            title: Text(
              "ร้านค้า",
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
            ),
            selectedColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
