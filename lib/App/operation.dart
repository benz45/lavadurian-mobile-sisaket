import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:velocity_x/velocity_x.dart';

class OperationPage extends StatefulWidget {
  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  SettingModel settingModel;
  UserModel userModel;
  StoreModel storeModel;
  ProductModel productModel;
  OrdertModel orderModel;
  ItemModel itemModel;

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    userModel = context.read<UserModel>();
    storeModel = context.read<StoreModel>();
    productModel = context.read<ProductModel>();
    orderModel = context.read<OrdertModel>();
    itemModel = context.read<ItemModel>();
  }

  // Get Store profile from server
  // Set data to state.
  Future<void> _getStoreProfile() async {
    String token = settingModel.value['token'];
    final response = await Http.get(
        '${settingModel.baseURL}/${settingModel.endPointGetStoreProfile}',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        });

    var jsonData = json.decode(utf8.decode(response.bodyBytes));

    // Set data to stores model
    List<Map<String, dynamic>> storeList = [];
    for (var store in jsonData['data']['stores']) {
      Map<String, dynamic> map = store;
      storeList.add(map);
    }
    storeModel.stores = storeList;

    // Set data to products model
    List<Map<String, dynamic>> productList = [];
    for (var product in jsonData['data']['products']) {
      Map<String, dynamic> map = product;
      productList.add(map);
    }
    productModel.products = productList;

    // Set data to orders model
    List<Map<String, dynamic>> orderList = [];
    for (var order in jsonData['data']['orders']) {
      Map<String, dynamic> map = order;
      productList.add(map);
    }
    orderModel.orders = orderList;

    // Set data to items model
    List<Map<String, dynamic>> itemList = [];
    for (var item in jsonData['data']['items']) {
      Map<String, dynamic> map = item;
      itemList.add(map);
    }
    itemModel.items = itemList;
  }

  Future<String> _getUserProfile() async {
    String token = settingModel.value['token'];

    // Get only one time after login
    if (userModel.value.isEmpty) {
      print("Connect...");
      final response = await Http.get(
          '${settingModel.baseURL}/${settingModel.endPointUserProfile}',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Token $token"
          });

      var jsonData = json.decode(utf8.decode(response.bodyBytes));

      for (var item in jsonData['results']) {
        userModel.value = {
          'url': item['url'],
          'id': item['id'],
          'username': item['username'],
          'first_name': item['first_name'],
          'last_name': item['last_name'],
          'email': item['email'],
        };
      }

      // Get Store profile after login success
      _getStoreProfile();

      return userModel.value.toString();
    } else {
      return userModel.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 66.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
    final items = List<String>.generate(20, (i) => 'item $i');

    return Scaffold(
      key: _drawerKey, // assign key to Scaffold
      endDrawerEnableOpenDragGesture: false, // THIS WAY IT WILL NOT OPEN
      drawer: NavDrawer(),
      body: Container(
        color: Colors.grey[50],
        child: CustomScrollView(slivers: [
          SliverAppBar(
            shadowColor: Colors.grey[50].withOpacity(0.3),
            backgroundColor: Colors.grey[50],
            automaticallyImplyLeading: false,
            pinned: true,
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: IconButton(
                        onPressed: () => _drawerKey.currentState.openDrawer(),
                        icon: Icon(Icons.menu),
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.person, color: kPrimaryColor),
                    ),
                  )
                ],
              ),
            ),
            expandedHeight: 260.0,
            flexibleSpace: FlexibleSpaceBar(
                background: Container(
              color: Colors.grey[50],
              padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 30),
              height: statusBarHeight + appBarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('ร้านค้า').text.xl2.semiBold.black.make().box.p12.make(),
                  VxSwiper.builder(
                    itemCount: 10,
                    height: 130,
                    viewportFraction: 0.55,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    isFastScrollingEnabled: false,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return "ร้านค้าที่ ${index + 1}"
                          .text
                          .black
                          .make()
                          .box
                          .rounded
                          .alignCenter
                          .color(kPrimaryLightColor)
                          .make()
                          .p4();
                    },
                  ),
                ],
              ),
            )),
          ),

          //
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                title: Text('รายการคำสั่งซื้อ').text.xl.black.semiBold.make(),
              ).pLTRB(16.0, 0.0, 16.0, 0.0),
              CardOrder().px32(),
              ListTile(
                title: Text('รายการสินค้า').text.xl.black.semiBold.make(),
              ).pLTRB(16.0, 16.0, 16.0, 0.0),
            ]),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.all(Radius.circular(18.0))),
                    child: Center(
                      child: Text('สินค้า'),
                    ),
                  );
                },
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class CardOrder extends StatelessWidget {
  const CardOrder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(13.5))),
                height: 100,
                width: 100,
                child: Text('รูปภาพ').centered(),
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ชื่อสินค้า')
                              .text
                              .extraBold
                              .make()
                              .pOnly(bottom: 8.0),
                          Text('ข้อมูลรายการสั่งซื้อสินค้า'),
                        ],
                      )).wFull(context),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text('ดูรายการสั่งซื้อ').text.bold.make()],
                      )).wFull(context).pOnly(right: 4.0),
                    ],
                  ))
            ],
          ),
        ));
  }
}
