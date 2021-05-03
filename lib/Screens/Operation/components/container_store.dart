import 'dart:convert';
import 'dart:io';
import 'package:LavaDurian/Screens/AllStatusOrder/all_status_order_screen.dart';
import 'package:LavaDurian/Screens/CreateProductDemo/create_product_demo_screen.dart';
import 'package:LavaDurian/Screens/Operation/components/body.dart';
import 'package:LavaDurian/Screens/Operation/components/dialog_store_status.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_appbar.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_list.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_order_list.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_page_four.dart';
import 'package:LavaDurian/Screens/Operation/components/store_wait_approval.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/bottomBar_model.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ContainerStore extends StatefulWidget {
  const ContainerStore({
    Key key,
  }) : super(key: key);

  @override
  _ContainerStoreState createState() => _ContainerStoreState();
}

class _ContainerStoreState extends State<ContainerStore> {
  RefreshController _controller = RefreshController();
  SettingModel settingModel;
  UserModel userModel;
  StoreModel storeModel;
  ProductModel productModel;
  OrdertModel orderModel;
  ItemModel itemModel;
  BookBankModel bookBankModel;
  ProductImageModel productImageModel;
  bool isGetUserProfile = true;

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
  }

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

      if (storeList.length != 0) {
        // Set persistent storage initial id store
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String currentStoreById =
            'USERID_${userModel.value['id']}_CURRENT_STORE';

        if (prefs.getInt(currentStoreById) != null) {
          storeModel.setCurrentStore(
              value: prefs.getInt(currentStoreById), user: currentStoreById);
        } else if (storeList != null) {
          prefs.setInt(currentStoreById, storeList.first['id']);
          storeModel.setCurrentStore(value: storeList.first['id']);
        }

        // Set store list
        storeModel.setStores = storeList;
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

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    await _getStoreProfile();
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 800));
  }

  void _onCheckStoreStatus() async {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
      message: "กำลังตรวจสอบ . . .",
    );
    await pr.show();
    await _getStoreProfile();
    pr.hide();

    // * Show alert dialog
    if (storeModel.getCurrentStoreStatus != 1) {
      showDialog(
        context: context,
        builder: (_) => checkStoreStatusDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size for custom screen.
    Size size = MediaQuery.of(context).size;
    final font = Theme.of(context).textTheme;

    return Container(
      color: Color(0xFFFAFAFA),
      child: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          //! Operation App Bar
          OperationAppBar(),

          //! Screen store approval success from admin.
          Consumer<StoreModel>(
            builder: (_, store, child) {
              return SliverAnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: store.getCurrentStoreStatus == 1
                    ? SliverToBoxAdapter(
                        child: Consumer<BottomBarModel>(
                          builder: (_, _bottomBarModel, c) {
                            return CarouselSlider(
                              carouselController: _bottomBarModel.getController,
                              options: CarouselOptions(
                                  viewportFraction: 1.0,
                                  initialPage: 0,
                                  height: size.height,
                                  enlargeCenterPage: true,
                                  onPageChanged:
                                      _bottomBarModel.setSelectedTabFromSlider),
                              items: [
                                //! 1. Home page on swiper.
                                Container(
                                  width: size.width * 0.85,
                                  child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    controller: _controller,
                                    onRefresh: _onRefresh,
                                    footer: ClassicFooter(
                                      iconPos: IconPosition.top,
                                      outerBuilder: (child) {
                                        return Container(
                                          width: 80.0,
                                          child: Center(
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                    header: ClassicHeader(
                                      refreshingText: 'กำลังโหลดข้อมูล',
                                      completeText: 'โหลดข้อมูลสำเร็จ',
                                      idleText: 'รีเฟรชข้อมูล',
                                      failedText: 'โหลดข้อมูลไม่สำเร็จ',
                                      releaseText: 'ปล่อยเพื่อรีเฟรชข้อมูล',
                                    ),
                                    onLoading: _onLoading,
                                    child: ListView(
                                      children: [
                                        // * List order
                                        OperationList(
                                          leading: 'รายการสั่งซื้อ',
                                          trailing: TextButton(
                                            child: Text(
                                              'ดูทั้งหมด',
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize:
                                                      font.subtitle2.fontSize,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              _bottomBarModel.setSelectedTab(1);
                                            },
                                          ),
                                        ),
                                        Consumer2<OrdertModel, ProductModel>(
                                            builder: (_, orderModel,
                                                productModel, c) {
                                          if (productModel.products != null &&
                                              productModel.products.length !=
                                                  0) {
                                            return Column(
                                              children: [
                                                if (orderModel.orders.length >
                                                    0)
                                                  OperationOrderList(
                                                    maxlength: 3,
                                                  ),
                                                if (orderModel.orders
                                                        .where((element) =>
                                                            element['status'] ==
                                                            1)
                                                        .length >
                                                    3)
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: OutlineButton(
                                                      highlightedBorderColor:
                                                          Colors.orange,
                                                      splashColor: Colors.orange
                                                          .withOpacity(0.1),
                                                      focusColor: Colors.white,
                                                      highlightColor: Colors
                                                          .orange
                                                          .withOpacity(0.2),
                                                      borderSide: BorderSide(
                                                          color: Colors.orange),
                                                      color: Colors.orange,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12))),
                                                      onPressed: () {
                                                        _bottomBarModel
                                                            .setSelectedTab(1);
                                                      },
                                                      child: Text(
                                                        'ขณะนี้มีรายคำสั่งซื้อใหม่มากกว่า 3 รายการ',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.orange),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }

                                          return SizedBox();
                                        }),

                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),

                                        // * List product
                                        OperationList(
                                          leading: 'รายการสินค้า',
                                          trailing: TextButton(
                                            child: Text(
                                              'ดูทั้งหมด',
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize:
                                                      font.subtitle2.fontSize,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              _bottomBarModel.setSelectedTab(2);
                                            },
                                          ),
                                        ),

                                        OperationProductList()
                                      ],
                                    ),
                                  ),
                                ),

                                //! 2. Orders page on swiper.
                                Container(
                                  width: size.width * 0.85,
                                  child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    controller: _controller,
                                    onRefresh: _onRefresh,
                                    footer: ClassicFooter(
                                      iconPos: IconPosition.top,
                                      outerBuilder: (child) {
                                        return Container(
                                          width: 80.0,
                                          child: Center(
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                    header: ClassicHeader(
                                      refreshingText: 'กำลังโหลดข้อมูล',
                                      completeText: 'โหลดข้อมูลสำเร็จ',
                                      idleText: 'รีเฟรชข้อมูล',
                                      failedText: 'โหลดข้อมูลไม่สำเร็จ',
                                      releaseText: 'ปล่อยเพื่อรีเฟรชข้อมูล',
                                    ),
                                    onLoading: _onLoading,
                                    child: ListView(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            OutlineButton(
                                              highlightColor:
                                                  kPrimaryLightColor,
                                              highlightedBorderColor:
                                                  kPrimaryColor,
                                              color: kPrimaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          AllStatusOrderScreen(
                                                              storeID: storeModel
                                                                  .getCurrentIdStore)),
                                                );
                                              },
                                              child: Text(
                                                'สถานะคำสั่งซื้อทั้งหมด',
                                                style: TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                            ),
                                            Icon(
                                              Icons.list,
                                              color: kTextSecondaryColor,
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        OperationList(
                                          leading: 'รายการสั่งซื้อ',
                                        ),
                                        OperationOrderList(),
                                        SizedBox(
                                          height: size.height * .4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //! 3. Products page on swiper.
                                Container(
                                  width: size.width * 0.85,
                                  child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    controller: _controller,
                                    onRefresh: _onRefresh,
                                    footer: ClassicFooter(
                                      iconPos: IconPosition.top,
                                      outerBuilder: (child) {
                                        return Container(
                                          width: 80.0,
                                          child: Center(
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                    header: ClassicHeader(
                                      refreshingText: 'กำลังโหลดข้อมูล',
                                      completeText: 'โหลดข้อมูลสำเร็จ',
                                      idleText: 'รีเฟรชข้อมูล',
                                      failedText: 'โหลดข้อมูลไม่สำเร็จ',
                                      releaseText: 'ปล่อยเพื่อรีเฟรชข้อมูล',
                                    ),
                                    onLoading: _onLoading,
                                    child: ListView(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            OutlineButton(
                                              highlightColor:
                                                  kPrimaryLightColor,
                                              highlightedBorderColor:
                                                  kPrimaryColor,
                                              color: kPrimaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        Consumer<StoreModel>(
                                                      builder:
                                                          (_, _storeModel, c) {
                                                        int stireId = _storeModel
                                                            .getCurrentIdStore;
                                                        return CreateProductDemoScreen(
                                                            backArrowButton:
                                                                true,
                                                            storeID: stireId);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'สร้างสินค้าใหม่',
                                                style: TextStyle(
                                                    color: kPrimaryColor),
                                              ),
                                            ),
                                            Icon(
                                              Icons.filter_list,
                                              color: kTextSecondaryColor,
                                            )
                                          ],
                                        ),
                                        Divider(),
                                        OperationList(
                                          leading: 'รายการสินค้า',
                                        ),
                                        OperationProductList()
                                      ],
                                    ),
                                  ),
                                ),

                                //! 4. Store page on swiper.

                                Container(
                                  width: size.width * .85,
                                  child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    controller: _controller,
                                    onRefresh: _onRefresh,
                                    footer: ClassicFooter(
                                      iconPos: IconPosition.top,
                                      outerBuilder: (child) {
                                        return Container(
                                          width: 80.0,
                                          child: Center(
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                    header: ClassicHeader(
                                      refreshingText: 'กำลังโหลดข้อมูล',
                                      completeText: 'โหลดข้อมูลสำเร็จ',
                                      idleText: 'รีเฟรชข้อมูล',
                                      failedText: 'โหลดข้อมูลไม่สำเร็จ',
                                      releaseText: 'ปล่อยเพื่อรีเฟรชข้อมูล',
                                    ),
                                    onLoading: _onLoading,
                                    child: OperationPageFour(),
                                  ),
                                ),
                              ].toList(),
                            );
                          },
                        ),
                      )
                    :
                    // //! Screen store waiting approval from admin.
                    // StoreWaitApproval(),
                    SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            StoreWaitApproval(),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  _onCheckStoreStatus();
                                },
                                child: Text(
                                  "ตรวจสอบการอนุมัติร้าน",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
