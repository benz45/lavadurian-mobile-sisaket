import 'dart:convert';
import 'dart:io';
import 'package:LavaDurian/Screens/ManageProduct/manage_product_screen.dart';
import 'package:LavaDurian/Screens/Operation/components/cardOrder.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_appbar.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_sliverlist.dart';
import 'package:LavaDurian/Screens/ManageOrder/manage_order_screen.dart';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:flutter/rendering.dart';

import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:velocity_x/velocity_x.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  SettingModel settingModel;
  UserModel userModel;
  StoreModel storeModel;
  ProductModel productModel;
  OrdertModel orderModel;
  ItemModel itemModel;

  Map<String, String> productGene;
  Map<String, String> orderStatus;
  Map<String, String> productStatus;

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    userModel = context.read<UserModel>();
    storeModel = context.read<StoreModel>();
    productModel = context.read<ProductModel>();
    orderModel = context.read<OrdertModel>();
    itemModel = context.read<ItemModel>();

    productGene = productModel.productGene;
    productStatus = productModel.productStatus;
    orderStatus = orderModel.orderStatus;
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
    if (jsonData['data']['stores'] != null) {
      List<Map<String, dynamic>> storeList = [];
      for (var store in jsonData['data']['stores']) {
        Map<String, dynamic> map = store;
        storeList.add(map);
      }
      storeModel.stores = storeList;
    }

    // Set data to products model
    if (jsonData['data']['products'] != null) {
      List<Map<String, dynamic>> productList = [];
      for (var product in jsonData['data']['products']) {
        Map<String, dynamic> map = product;
        productList.add(map);
      }
      productModel.products = productList;
    }

    // Set data to orders model
    if (jsonData['data']['orders'] != null) {
      List<Map<String, dynamic>> orderList = [];
      for (var order in jsonData['data']['orders']) {
        Map<String, dynamic> map = order;
        orderList.add(map);
      }
      orderModel.orders = orderList;
    }

    // Set data to items model
    if (jsonData['data']['items'] != null) {
      List<Map<String, dynamic>> itemList = [];
      for (var item in jsonData['data']['items']) {
        Map<String, dynamic> map = item;
        itemList.add(map);
      }
      itemModel.items = itemList;
    }
  }

  Future<String> _getUserProfile() async {
    String token = settingModel.value['token'];

    // Get only one time after login
    if (userModel.value.isEmpty) {
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
      await _getStoreProfile();

      return userModel.value.toString();
    } else {
      return userModel.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.grey[50],
            child: CustomScrollView(slivers: [
              OperationAppBar(),
              OperationSliverList(
                leading: 'รายการสั่งซื้อ',
                trailing: 'จัดการคำสั่งซื้อ',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => OrderScreen()));
                },
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: 18.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return CardOrder(
                        order: orderModel.orders[index],
                      ).px32();
                    },
                    childCount: orderModel.orders.length,
                  ),
                ),
              ),
              OperationSliverList(
                leading: 'รายการสินค้า',
                trailing: 'จัดการสินค้า',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ManageProductScreen()));
                },
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 18.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: MediaQuery.of(context).size.height /
                        (MediaQuery.of(context).size.width * 0.91),
                    mainAxisSpacing: 16.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final product = productModel.products;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewProductScreen(
                                hero: '$index',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(18.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Hero(
                                tag: '$index',
                                child: Container(
                                  height: double.infinity,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(18.0)),
                                    image: DecorationImage(
                                      fit: BoxFit
                                          .cover, //I assumed you want to occupy the entire space of the card
                                      image: AssetImage(
                                        'assets/images/example.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${productGene[product[index]['gene'].toString()]}"),
                                      Text(
                                          "จำนวน: ${product[index]['values']}"),
                                      Text("นน.: ${product[index]['weight']}"),
                                      Text("ราคา: ${product[index]['price']}"),
                                      Text(
                                          "สถานะ: ${productStatus[productModel.products[index]['status'].toString()]}"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: productModel.products.length,
                  ),
                ),
              )
            ]),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}