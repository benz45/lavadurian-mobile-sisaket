import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Lava Durian Online'),
        // automaticallyImplyLeading: false,
      ),
      drawer: NavDrawer(),
      body: Background(
        child: FutureBuilder(
          future: _getUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "${userModel.value['first_name']} ${userModel.value['last_name']}"),
                  ],
                ),
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
        ),
      ),
    );
  }
}
