import 'dart:convert';
import 'dart:io';
import 'package:LavaDurian/Screens/CreateProduct/create_product_screen.dart';
import 'package:LavaDurian/Screens/Login/login_screen.dart';
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

      // Set persistent storage initial id store
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String currentStoreById = 'USERID_${userModel.value['id']}_CURRENT_STORE';

      if (prefs.getInt(currentStoreById) != null) {
        storeModel.setCurrentStore(
            value: prefs.getInt(currentStoreById), user: currentStoreById);
      } else {
        prefs.setInt(currentStoreById, storeList.first['id']);
        storeModel.setCurrentStore(value: storeList.first['id']);
      }

      // Set store list
      storeModel.setStores = storeList;
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

class ContainerStore extends StatelessWidget {
  const ContainerStore({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Size for custom screen.
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.grey[50],
      child: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        primary: true,
        slivers: [
          //! Operation App Bar
          OperationAppBar(),

          //! Screen store approval success from admin.
          Consumer<StoreModel>(
            builder: (_, store, child) {
              if (store.getCurrentStoreStatus == 1) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: size.height,
                    child: Consumer<BottomBarModel>(
                      builder: (_, bottomBarModel, c) {
                        return CarouselSlider(
                          carouselController: bottomBarModel.getController,
                          options: CarouselOptions(
                              viewportFraction: 1.0,
                              initialPage: 0,
                              height: size.height,
                              enlargeCenterPage: true,
                              onPageChanged:
                                  bottomBarModel.setSelectedTabFromSlider),
                          items: [
                            //! Home page on swiper.
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  StoreApproval(),
                                  Consumer2<OrdertModel, ProductModel>(builder:
                                      (_, orderModel, productModel, c) {
                                    if (productModel.products != null &&
                                        productModel.products.length != 0) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            if (orderModel.orders.length > 0)
                                              OperationOrderList(),
                                          ],
                                        ),
                                      );
                                    }

                                    return Container();
                                  }),
                                  OperationProductList()
                                ],
                              ),
                            ),

                            //! Orders page on swiper.
                            Consumer<OrdertModel>(builder: (_, orderModel, c) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (orderModel.orders.length > 0)
                                      OperationOrderList(),
                                  ],
                                ),
                              );
                            }),

                            //! Products page on swiper.
                            SingleChildScrollView(
                              child: Column(
                                children: [OperationProductList()],
                              ),
                            ),

                            //! Store page on swiper.
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Center(
                                    child: Text('Store Coming soon...'),
                                  )
                                ],
                              ),
                            ),
                          ].toList(),
                        );
                      },
                    ),
                  ),
                );
              }
              // Return Default.
              return SliverToBoxAdapter();
            },
          ),

          //! Screen store waiting approval from admin.
          Consumer<StoreModel>(
            builder: (_, store, child) {
              // print(store.getCurrentStoreStatus.runtimeType);
              if (store.getCurrentStoreStatus == 0) {
                return StoreWaitApproval();
              }
              // Return Default.
              return SliverToBoxAdapter();
            },
          )
        ],
      ),
    );
  }
}

class OperationOrderList extends StatelessWidget {
  const OperationOrderList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<OrdertModel>(builder: (_, orderModel, c) {
          if (orderModel.orders != null && orderModel.orders.length != 0) {
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
          return Container();
        }),
      ],
    );
  }
}

class OperationProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Consumer<ProductModel>(builder: (_, productModel, c) {
          if (productModel.products.length != null &&
              productModel.products.length != 0) {
            return OperationList(
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
            );
          }

          return Container();
        }),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: OperationCardProduct(),
        ),
        SizedBox(
          height: size.height * 0.37,
        ),
      ],
    );
  }
}

class StoreApproval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer2<StoreModel, ProductModel>(
      builder: (context, storeModel, productModel, child) {
        if (productModel.products.length == 0) {
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
                            storeID: storeModel.getCurrentIdStore,
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
        // Reture Default.
        return Container();
      },
    );
  }
}

class StoreWaitApproval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Container(
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
      ),
    );
  }
}
