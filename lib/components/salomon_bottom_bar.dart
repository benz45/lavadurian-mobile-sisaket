import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/bottomBar_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MySalomonBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BottomBarModel bottomBarModel = Provider.of<BottomBarModel>(context);
    StoreModel storeModel = Provider.of<StoreModel>(context);

    // * check store status
    int storeStatus = storeModel.getCurrentStoreStatus;

    return storeModel.getStores.length != 0 && storeModel.getCurrentIdStore != null && (storeStatus == 1 || storeStatus == 3)
        ? SafeArea(
            child: SalomonBottomBar(
              currentIndex: bottomBarModel.getCurrentSelectedTab,
              onTap: bottomBarModel.setSelectedTab,
              items: [
                SalomonBottomBarItem(
                  activeIcon: Icon(
                    Icons.home_outlined,
                    color: kPrimaryColor,
                  ),
                  icon: Icon(
                    Icons.home_outlined,
                    color: kTextSecondaryColor,
                  ),
                  title: Text(
                    "หน้าหลัก",
                    style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
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
                    style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
                  ),
                  selectedColor: kPrimaryColor,
                ),
                SalomonBottomBarItem(
                  activeIcon: Icon(
                    Icons.shopping_basket_outlined,
                    color: kPrimaryColor,
                  ),
                  icon: Icon(
                    Icons.shopping_basket_outlined,
                    color: kTextSecondaryColor,
                  ),
                  title: Text(
                    "สินค้า",
                    style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
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
                    style: TextStyle(fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily),
                  ),
                  selectedColor: kPrimaryColor,
                ),
              ],
            ),
          )
        : SizedBox();
  }
}
