import 'package:LavaDurian/Screens/Operation/components/operation_card_order.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class OperationOrderList extends StatefulWidget {
  final int maxlength;
  const OperationOrderList({Key key, this.maxlength}) : super(key: key);

  @override
  _OperationOrderListState createState() => _OperationOrderListState();
}

class _OperationOrderListState extends State<OperationOrderList> {
  Widget buildList() {
    Size size = MediaQuery.of(context).size;
    return Consumer2<StoreModel, OrdertModel>(
      builder: (_, storeModel, orderModel, c) {
        // * Fillter for order list in current store
        var orders =
            orderModel.getOrdersFromStoreId(storeModel.getCurrentIdStore);

        if (orders != null && orders.length != 0) {
          return ListView.builder(
              padding: EdgeInsets.only(top: 0),
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return OperationCardOrder(
                  orderId: orders[index]['id'],
                );
              },
              itemCount: widget.maxlength != null &&
                      orderModel.orders.length > widget.maxlength
                  ? widget.maxlength
                  : orders.length);
        } else {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/undraw_inbox_cleanup_w2ur.svg',
                  width: size.width * 0.40,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "ยังไม่มีรายการสั่งซื้อ",
                  style: TextStyle(color: kTextSecondaryColor),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildList();
  }
}
