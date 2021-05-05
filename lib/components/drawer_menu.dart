import 'package:LavaDurian/Screens/CreateProductDemo/create_product_demo_screen.dart';
import 'package:LavaDurian/Screens/CreateStore/create_store_screen.dart';
import 'package:LavaDurian/Screens/Developer/developer_screen.dart';
import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/Screens/Welcome/welcome_screen.dart';
import 'package:LavaDurian/class/file_process.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  UserModel userModel;
  StoreModel storeModel;

  @override
  void initState() {
    super.initState();
    userModel = context.read<UserModel>();
    storeModel = context.read<StoreModel>();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    Future<void> _logout() async {
      FileProcess fileProcess = FileProcess('setting.json');
      try {
        userModel.clear();
        fileProcess.writeData('{}');

        // Clear Navigate route
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WelcomeScreen()), (Route<dynamic> route) => false);
      } catch (e) {
        print(e);
      }
    }

    return Drawer(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                    ),
                    accountName: Text(
                      "${userModel.value['first_name']} ${userModel.value['last_name']}",
                      style: TextStyle(fontSize: textTheme.headline6.fontSize, color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(
                      "${userModel.value['email']}",
                      style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: Text(
                      'หน้าแรก',
                      style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OperationScreen()));
                    },
                  ),
                  storeModel.getCurrentStoreStatus == 1
                      ? Container(
                          child: Column(
                          children: [
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.storefront_rounded),
                              title: Text(
                                'สร้างร้านค้า',
                                style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateStoreScreen()));
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.shopping_basket_outlined),
                              title: Text(
                                'สร้างสินค้า',
                                style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Consumer<StoreModel>(
                                      builder: (_, storeModel, __) {
                                        return CreateProductDemoScreen(backArrowButton: true, storeID: storeModel.getCurrentIdStore);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ))
                      : Container(),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings_outlined),
                    title: Text(
                      'ผู้พัฒนา',
                      style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DeveloperScreen()));
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'ออกจากระบบ',
                  style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                ),
                onTap: () {
                  _logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
