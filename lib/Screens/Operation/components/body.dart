import 'dart:convert';
import 'dart:io';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
import 'package:LavaDurian/Screens/Operation/components/container_store.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_card_product.dart';
import 'package:LavaDurian/Screens/StoreNoData/store_no_data.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

import 'package:shared_preferences/shared_preferences.dart';

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
  BookBankModel bookBankModel;
  ProductImageModel productImageModel;
  bool isGetUserProfile = true;

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
    bookBankModel = context.read<BookBankModel>();
    productImageModel = context.read<ProductImageModel>();

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

      // Set store list
      storeModel.setStores = storeList;

      if (storeList.length != 0) {
        // Set persistent storage initial id store
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String keyStoreForPrefs =
            'USERID_${userModel.value['id']}_CURRENT_STORE';

        var storeidFromPrefs = prefs.getInt(keyStoreForPrefs);

        if (storeidFromPrefs == null) {
          storeModel.setCurrentStore(
              value: storeList.first['id'], user: userModel.value['id']);
          return;
        }

        final isContainsStore = storeList.firstWhere(
            (element) => element['id'] == storeidFromPrefs,
            orElse: () => null);

        if (isContainsStore != null) {
          storeModel.setCurrentStore(
              value: storeidFromPrefs, user: userModel.value['id']);
        } else {
          storeModel.setCurrentStore(
              value: storeList[0]['id'], user: userModel.value['id']);
        }
      }
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

    // Set data to ordersItems model
    if (jsonData['data']['orderItems'] != null) {
      List<Map<String, dynamic>> orderList = [];
      for (var order in jsonData['data']['orderItems']) {
        Map<String, dynamic> map = order;
        orderList.add(map);
      }
      orderModel.orderItems = orderList;
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

    if (jsonData['data']['bookbank'] != null) {
      List<Map<String, dynamic>> bookbankList = [];
      for (var bookbank in jsonData['data']['bookbank']) {
        Map<String, dynamic> map = bookbank;
        bookbankList.add(map);
      }
      bookBankModel.bookbank = bookbankList;
    }

    if (jsonData['data']['images'] != null) {
      List<Map<String, dynamic>> imageList = [];
      for (var image in jsonData['data']['images']) {
        Map<String, dynamic> map = image;
        imageList.add(map);
      }
      productImageModel.images = imageList;
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
      if (jsonData['results'] != null) {
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
      }
      // ! Error code 101
      return '101';
    } else {
      return userModel.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    StoreModel store = Provider.of<StoreModel>(context);

    return FutureBuilder(
      future: _getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // ! Error code 101
          if (snapshot.data == '101') {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '101',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize:
                            Theme.of(context).textTheme.headline3.fontSize),
                  ),
                ),
                Container(
                  child: Text('เกิดข้อผิดพลาด กรุณาเข้าสู่ระบบใหม่ออีกครั้ง'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ],
            );
          }

          // * Fetch data success
          if (store.getCurrentIdStore != null && store.getStores.length != 0) {
            // Screen for user have store data.
            return ContainerStore();
          } else {
            // Screen for user not yet store data.
            return StoreNodata();
          }
        } else {
          // ! Fetching data
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }
      },
    );
  }
}

class OperationProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        OperationCardProduct(),
        SizedBox(
          height: size.height * 0.37,
        ),
      ],
    );
  }
}
