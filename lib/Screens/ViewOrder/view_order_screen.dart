import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

class ViewOrderScreen extends StatefulWidget {
  final Map order;
  const ViewOrderScreen({Key key, this.order}) : super(key: key);

  @override
  _ViewOrderScreenState createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  AnimationController animateController;
  OrdertModel orderModel;
  ProductModel productModel;
  @override
  void initState() {
    orderModel = context.read<OrdertModel>();
    productModel = context.read<ProductModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    // Filter index id on orderItems id.
    final Map mapOrder = orderModel.orders
        .firstWhere((e) => e['id'] == widget?.order['id'], orElse: () => {});

    // Filter index id on orderItems id.
    final Map mapOrderItems = orderModel.orderItems
        .firstWhere((e) => e['order'] == mapOrder['id'], orElse: () => {});

    //If there are no elements in this mapOrderItems.
    if (mapOrder.isEmpty) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text('สินค้าของผู้ขายถูกลบไปแล้ว'),
            ),
            OutlineButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OperationScreen(),
                  ),
                );
              },
              child: Text('ย้อนกลับ'),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Container(
            color: Colors.grey[50],
            child: CustomScrollView(
              slivers: [
                // ! App bar
                SliverAppBar(
                  floating: false,
                  elevation: 0,
                  shadowColor: Colors.grey[50].withOpacity(0.3),
                  backgroundColor: Colors.grey[50],
                  automaticallyImplyLeading: false,
                  leading: Container(
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_rounded),
                      color: kTextPrimaryColor,
                    ),
                  ),
                ),

                // ! Title header
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      width: size.width * 0.9,
                      margin: EdgeInsets.only(bottom: size.height * 0.028),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'รายการคำสั่งซื้อ',
                                style: textTheme.headline6,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '#${mapOrder['id']}',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: textTheme.headline6.fontSize,
                                    fontWeight: textTheme.headline6.fontWeight),
                              ),
                            ],
                          ),
                          Consumer<StoreModel>(builder: (_, _storeModel, c) {
                            return Text(
                              _storeModel.getCurrentStore[0]['name'],
                              style: TextStyle(
                                  color: kTextSecondaryColor,
                                  fontWeight: FontWeight.bold),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                // ! Box status
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(22),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.04),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      width: size.width * 0.9,
                      child: Consumer<OrdertModel>(
                        builder: (_, _ordertModel, c) {
                          // Filter orders by id

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // * Box status header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'สถานะคำสั่งซื้อ',
                                    style: TextStyle(
                                        color: kTextSecondaryColor,
                                        fontSize: textTheme.subtitle1.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (mapOrder['status'] != 8)
                                    Row(
                                      children: [
                                        Text(
                                          'ขั้นตอนที่',
                                          style: TextStyle(
                                              color: kTextSecondaryColor,
                                              fontSize:
                                                  textTheme.subtitle1.fontSize,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          '${mapOrder['status']}/7',
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize:
                                                  textTheme.subtitle1.fontSize,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 26, bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '${_ordertModel.orderStatus['${mapOrder['status']}']}',
                                      style: TextStyle(
                                          fontSize:
                                              textTheme.subtitle1.fontSize + 4,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconStepper(
                                    stepReachedAnimationEffect:
                                        Curves.fastOutSlowIn,
                                    stepColor:
                                        kTextSecondaryColor.withOpacity(0.15),
                                    nextButtonIcon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: textTheme.subtitle1.fontSize,
                                      color: kTextSecondaryColor,
                                    ),
                                    enableNextPreviousButtons: false,
                                    steppingEnabled: false,
                                    scrollingDisabled: false,
                                    previousButtonIcon: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: textTheme.subtitle1.fontSize,
                                      color: kTextSecondaryColor,
                                    ),
                                    activeStepBorderColor:
                                        mapOrder['status'] == 8
                                            ? Colors.red[300]
                                            : kPrimaryColor.withOpacity(0.75),
                                    activeStepColor: mapOrder['status'] == 8
                                        ? Colors.red[300]
                                        : kPrimaryColor.withOpacity(0.75),
                                    lineColor: kTextSecondaryColor,
                                    icons: mapOrder['status'] != 8
                                        ? [
                                            Icon(
                                              Icons.flag_outlined,
                                              color: Colors.white,
                                            ),
                                            Icon(
                                              Icons.access_time_sharp,
                                              color: Colors.white,
                                            ),
                                            Icon(
                                              Icons.fact_check_outlined,
                                              color: Colors.white,
                                            ),
                                            Icon(
                                              Icons.mobile_friendly,
                                              color: Colors.white,
                                            ),
                                            Icon(
                                              Icons.delivery_dining,
                                              color: Colors.white,
                                            ),
                                            Icon(
                                              Icons
                                                  .assignment_turned_in_outlined,
                                              color: Colors.white,
                                            ),
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                            ),
                                          ]
                                        : [
                                            Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ],
                                    activeStep: mapOrder['status'] != 8
                                        ? mapOrder['status'] - 1
                                        : 0,
                                  ),
                                ],
                              ),
                              Divider(
                                height: 36,
                              ),
                              // ! Box change status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // * จัดการสถานะคำสั่งซื้อ
                                  Center(
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(29)),
                                      onPressed: () {},
                                      color: kPrimaryColor,
                                      child: Text(
                                        'เปลี่ยนสถานะคำสั่งซื้อ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ! รายละเอียดสินค้า
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
                  sliver: ViewOrderDetailProduct(
                    productId: /*value product id ->*/ mapOrderItems['product'],
                  ),
                ),
                // ! รายละเอียดผู้ซื้อ & รายละเอียดผู้ซื้อ
                SliverPadding(
                  padding: EdgeInsets.only(top: 20),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(22),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.04),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        width: size.width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // * 1. รายละเอียดผู้ซื้อ
                            BuildHeadText(text: 'รายละเอียดผู้ชื้อ'),
                            BuildSubText(
                              leading: 'ชื่อ',
                              text: '${widget.order['owner']}',
                            ),
                            BuildSubText(
                              leading: 'ที่อยู่',
                              text: '${widget.order['receive_address']}',
                              width: MediaQuery.of(context).size.width * .4,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),

                            Divider(
                              height: size.height * 0.05,
                            ),

                            // * 2. รายละเอียดผู้ซื้อ

                            BuildSubText(
                              leading: 'น้ำหนักที่สั่งซื้อ',
                              text: '${mapOrderItems['price_kg']}',
                            ),
                            BuildSubText(
                              leading: 'ค่าจัดส่ง',
                              text: '${widget.order['shipping']}',
                            ),
                            BuildSubText(
                              leading: 'รวมราคา',
                              text: '${mapOrderItems['price']}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: size.height * 0.1),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

class ViewOrderDetailProduct extends StatelessWidget {
  final int productId;
  const ViewOrderDetailProduct({
    Key key,
    @required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ProductModel>(
      builder: (_, _productModel, c) {
        // Filter product id on the mapOrderItems id.
        final Map mapProduct = _productModel.products
            .firstWhere((e) => e['id'] == productId, orElse: () => {});

        // Filter product gene.
        final String mapProductGene =
            _productModel.productGene['${mapProduct['gene']}'];

        return SliverToBoxAdapter(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.04),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: size.width * 0.9,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'รายละเอียดสินค้า',
                        style: TextStyle(
                            color: kTextSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                Theme.of(context).textTheme.subtitle1.fontSize),
                      ),
                      Icon(
                        Icons.more_vert_rounded,
                        size: Theme.of(context).textTheme.subtitle1.fontSize,
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewProductScreen(
                            productId: mapProduct['id'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: size.height * 0.09,
                      width: size.height * 0.09,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
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
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              '$mapProductGene',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kTextPrimaryColor,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .fontSize),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'เกรดทุเรียน',
                              style: TextStyle(color: kTextSecondaryColor),
                            ),
                            Text(
                              '${_productModel.productGrade['${mapProduct['grade']}']}',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'น้ำหนัก (กก.)',
                              style: TextStyle(color: kTextSecondaryColor),
                            ),
                            Text(
                              '${mapProduct['weight']} กก.',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ราคา (ต่อ/กก.)',
                              style: TextStyle(
                                color: kTextSecondaryColor,
                              ),
                            ),
                            Text(
                              '${mapProduct['price']} บาท',
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BuildHeadText extends StatelessWidget {
  final String text;
  const BuildHeadText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: TextStyle(
            color: kTextSecondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.subtitle1.fontSize),
      ),
    );
  }
}

class BuildSubText extends StatelessWidget {
  final String leading;
  final String text;
  final double width;
  const BuildSubText({Key key, this.text, this.leading, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leading,
            style: TextStyle(
                color: kTextSecondaryColor,
                fontSize: Theme.of(context).textTheme.subtitle2.fontSize),
          ),
          Container(
            width: width,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle2.fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
