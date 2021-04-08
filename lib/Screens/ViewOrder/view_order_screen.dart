import 'dart:ffi';

import 'package:LavaDurian/Screens/ViewOrder/components/view_order_appbar.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_bottomSheet.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_deleted.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_detail_order.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_detail_product.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_header_title.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_manage_status.dart';
import 'package:LavaDurian/components/GetSize.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

// ! Provider Size View Order Model For Custom Size
class SizeViewOrderModel with ChangeNotifier {
  Size size;
  set setSize(Size s) => {size = s, notifyListeners()};
  Size get getSize => size;
}

class ViewOrderScreen extends StatefulWidget {
  final Map order;
  const ViewOrderScreen({Key key, this.order}) : super(key: key);

  @override
  _ViewOrderScreenState createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animateController;
  OrdertModel orderModel;
  ProductModel productModel;

  @override
  void initState() {
    super.initState();
    orderModel = context.read<OrdertModel>();
    productModel = context.read<ProductModel>();
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
                  padding: EdgeInsets.only(bottom: size.height * 0.06),
                ),
                SliverToBoxAdapter(
                  child: Consumer<SizeViewOrderModel>(
                      builder: (_, _sizeViewOrderModel, c) {
                    return SizedBox(
                      height: _sizeViewOrderModel.getSize?.height ?? 0.0,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          child: Consumer2<OrdertModel, SizeViewOrderModel>(
            builder: (_, _orderModel, _sizeViewOrderModel, c) {
              final _order = _orderModel.getOrderFromId(mapOrderItems['order']);
              return _order['status'] == 1 || _order['status'] >= 4
                  ? Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ]),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom * 0.7),
                      child: GetSize(
                        onChange: (Size size) {
                          _sizeViewOrderModel.setSize = size;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.024,
                              horizontal: size.width * 0.06),
                          child: ViewOrderBottomSheet(
                              mapOrderItems: mapOrderItems),
                        ),
                      ),
                    )
                  : SizedBox();
            },
          ),
        ),
      );
    }
  }
}
