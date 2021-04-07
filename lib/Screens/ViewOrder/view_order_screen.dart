import 'package:LavaDurian/Screens/ViewOrder/components/view_order_appbar.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_deleted.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_detail_order.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_detail_product.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_header_title.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_manage_status.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
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

    // f: Filter index id on orderItems id.
    final Map mapOrder = orderModel.orders
        .firstWhere((e) => e['id'] == widget?.order['id'], orElse: () => {});

    // f: Filter index id on orderItems id.
    final Map mapOrderItems = orderModel.orderItems
        .firstWhere((e) => e['order'] == mapOrder['id'], orElse: () => {});

    //If there are no elements in this mapOrderItems.
    if (mapOrder.isEmpty) {
      return ViewOrderDeleted();
    } else {
      return Scaffold(
        body: Center(
          child: Container(
            color: Colors.grey[50],
            child: CustomScrollView(
              slivers: [
                // w: App bar
                ViewOrderAppBar(),

                // w: Header title
                ViewOrderHeaderTitle(mapOrder: mapOrder),

                // w: จัดการสถานะ
                ViewOrderManageStatus(mapOrder: mapOrder),

                // w: รายละเอียดสินค้า
                ViewOrderDetailProduct(
                  productId: /*value product id ->*/ mapOrderItems['product'],
                ),
                // w: รายละเอียดคำสั่งซื้อ
                ViewOrderDetailOrder(
                  orderItems: mapOrderItems,
                  orders: mapOrder,
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
