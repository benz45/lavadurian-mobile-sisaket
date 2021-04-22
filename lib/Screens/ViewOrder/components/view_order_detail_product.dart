import 'package:LavaDurian/Screens/ViewOrder/components/view_order_detail_orderItem.dart';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewOrderDetailProduct extends StatefulWidget {
  final int orderId;
  const ViewOrderDetailProduct({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  @override
  _ViewOrderDetailProductState createState() => _ViewOrderDetailProductState();
}

class _ViewOrderDetailProductState extends State<ViewOrderDetailProduct> {
  int orderId;
  @override
  void initState() {
    super.initState();
    orderId = widget.orderId;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverPadding(
      padding: const EdgeInsets.only(top: 20.0),
      sliver: Consumer2<ProductModel, ProductImageModel>(
        builder: (_, _productModel, productImageModel, c) {
          return SliverToBoxAdapter(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.04),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: size.width * 0.9,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    // ! Header title
                    Row(
                      children: [
                        Text(
                          'รายละเอียดสินค้า',
                          style: TextStyle(
                              color: kTextSecondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .fontSize),
                        ),
                      ],
                    ),
                    Divider(),
                    // ! list order items
                    Consumer<OrdertModel>(builder: (_, ordertModel, __) {
                      final Map mapOrder = ordertModel.getOrderFromId(orderId);
                      final List listOrderItems =
                          ordertModel.getOrderItemFromId(orderId);

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        itemCount: listOrderItems.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'รายการที่ ${index + 1}',
                                    style: TextStyle(
                                        color: kTextSecondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .fontSize),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ViewProductScreen(
                                            productId: listOrderItems[index]
                                                ['product'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ไปยังสินค้า',
                                          style: TextStyle(
                                              color: kTextSecondaryColor,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .fontSize),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: kTextSecondaryColor,
                                          size: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .fontSize,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),

                              // ! Image product
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ViewProductScreen(
                                        productId: listOrderItems[index]
                                            ['product'],
                                      ),
                                    ),
                                  );
                                },
                                child: productImageModel
                                            .getProductImageFromProductId(
                                                productId: listOrderItems[index]
                                                    ['product'])
                                            .length !=
                                        0
                                    ? CachedNetworkImage(
                                        imageUrl: productImageModel
                                            .getProductImageFromProductId(
                                                productId: listOrderItems[index]
                                                    ['product'])[0]['image'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: size.height * 0.09,
                                          width: size.height * 0.09,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18.0)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: size.height * 0.09,
                                          width: size.height * 0.09,
                                          color:
                                              Colors.grey[400].withOpacity(.75),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18.0)),
                                          ),
                                          child: Icon(
                                            Icons.error_outline_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: size.height * 0.09,
                                        width: size.height * 0.09,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18.0)),
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

                              // ! Content
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // * Product name
                                    Center(
                                      child: Text(
                                        '${_productModel.getProductGeneFromId(productId: listOrderItems[index]['product'])}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kTextPrimaryColor,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .fontSize),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        '${_productModel.getProductGradeFromId(productId: listOrderItems[index]['product'])}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kTextSecondaryColor,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .fontSize),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ViewOrderDetailOrderItem(
                                  order: mapOrder,
                                  orderItems: listOrderItems[index]),
                              Divider(
                                height: 46,
                              )
                            ],
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
