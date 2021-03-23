import 'dart:convert';
import 'dart:io';
import 'package:LavaDurian/Screens/CreateProduct/create_product_screen.dart';
import 'package:LavaDurian/Screens/ManageProduct/manage_product_screen.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_card_order.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_appbar.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_card_product.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_list.dart';
import 'package:LavaDurian/Screens/ManageOrder/manage_order_screen.dart';
import 'package:LavaDurian/Screens/StoreNoData/store_no_data.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/bottomBar_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';

import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

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
    Size size = MediaQuery.of(context).size;

    BottomBarModel bottomBarModel = Provider.of<BottomBarModel>(context);
    StoreModel store = Provider.of<StoreModel>(context);

    return FutureBuilder(
      future: _getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (storeModel.stores.length != 0) {
            return Container(
              color: Colors.grey[50],
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                primary: true,
                slivers: [
                  OperationAppBar(),
                  if (storeModel.getCurrentStoreStatus == 0)
                    SliverToBoxAdapter(
                      child: StoreWaitApproval(),
                    ),
                  if (storeModel.getCurrentStoreStatus == 1)
                    Builder(builder: (context) {
                      return SliverToBoxAdapter(
                        child: Container(
                          height: size.height,
                          child: CarouselSlider(
                            carouselController: bottomBarModel.getController,
                            options: CarouselOptions(
                                viewportFraction: 1.0,
                                initialPage: 0,
                                height: size.height,
                                enlargeCenterPage: true,
                                onPageChanged:
                                    bottomBarModel.setSelectedTabFromSlider),
                            items: [
                              // Home Page
                              HOCpage(
                                widget: [
                                  if (productModel.products.length == 0)
                                    StoreApproval(storeId: store.stores),
                                  if (orderModel.orders.length > 0)
                                    OperationOrderList(orderModel: orderModel),
                                  if (productModel.products.length > 0)
                                    OperationProductList(
                                        productModel: productModel,
                                        productGene: productGene,
                                        productStatus: productStatus)
                                ],
                              ),
                              // Orders Page
                              HOCpage(
                                widget: [
                                  if (orderModel.orders.length > 0)
                                    OperationOrderList(orderModel: orderModel),
                                ],
                              ),
                              // Products Page
                              HOCpage(
                                widget: [
                                  if (productModel.products.length > 0)
                                    OperationProductList(
                                        productModel: productModel,
                                        productGene: productGene,
                                        productStatus: productStatus)
                                ],
                              ),
                              // Store Page
                              HOCpage(
                                widget: [
                                  Center(
                                    child: Text('Store Coming soon...'),
                                  )
                                ],
                              ),
                            ].toList(),
                          ),
                        ),
                      );
                    })
                ],
              ),
            );
          } else {
            return StoreNodata();
          }
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

// Higher order components
class HOCpage extends StatelessWidget {
  final List<Widget> widget;
  HOCpage({Key key, this.widget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: widget,
      ),
    );
  }
}

class OperationOrderList extends StatelessWidget {
  const OperationOrderList({
    Key key,
    @required this.orderModel,
  }) : super(key: key);

  final OrdertModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OperationList(
          leading: 'รายการสั่งซื้อ',
          trailing: 'จัดการคำสั่งซื้อ',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderScreen(),
              ),
            );
          },
        ),
        Container(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 8),
                child: OperationCardOrder(
                  order: orderModel.orders[index],
                ),
              );
            },
            itemCount: orderModel.orders.length,
          ),
        ),
      ],
    );
  }
}

class OperationProductList extends StatelessWidget {
  const OperationProductList({
    Key key,
    @required this.productModel,
    @required this.productGene,
    @required this.productStatus,
  }) : super(key: key);

  final ProductModel productModel;
  final Map<String, String> productGene;
  final Map<String, String> productStatus;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        OperationList(
          leading: 'รายการสินค้า',
          trailing: 'จัดการสินค้า',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ManageProductScreen(),
              ),
            );
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: OperationCardProduct(
              productModel: productModel,
              productGene: productGene,
              productStatus: productStatus),
        ),
        SizedBox(
          height: size.height * 0.37,
        ),
      ],
    );
  }
}

class StoreApproval extends StatelessWidget {
  const StoreApproval({
    Key key,
    @required this.storeId,
  }) : super(key: key);

  final List<Map<String, dynamic>> storeId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/undraw_add_product.svg",
            width: size.width * 0.40,
          ),
          SizedBox(
            height: 16.0,
          ),
          Center(
            child: FlatButton(
              height: 40,
              color: kPrimaryColor.withOpacity(0.15),
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 25),
              splashColor: kPrimaryColor.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "สร้างสินค้าของคุณ",
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // ignore: todo
                // TODO: Navigate to create product screen.

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateProductScreen(
                      storeID: storeId[0]['id'],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoreWaitApproval extends StatelessWidget {
  const StoreWaitApproval({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/undraw_confirmation.svg",
            width: size.width * 0.40,
          ),
          SizedBox(
            height: 16.0,
          ),
          Center(
            child: Text(
              'กำลังรอการ "อนุมัติร้านค้า" จากผู้ดูแลระบบ',
              style: TextStyle(
                  color: kTextSecondaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
