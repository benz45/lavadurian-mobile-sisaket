import 'package:LavaDurian/Screens/ViewOrder/components/view_order_bottomSheet_status_eight.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_bottomSheet_status_fire.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_bottomSheet_status_four.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_bottomSheet_status_one.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_bottomSheet_status_seven.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_bottomSheet_status_six.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ViewOrderBottomSheet extends StatefulWidget {
  ViewOrderBottomSheet({
    Key key,
    @required this.mapOrderItems,
  }) : super(key: key);

  final Map mapOrderItems;

  @override
  _ViewOrderBottomSheetState createState() => _ViewOrderBottomSheetState();
}

class _ViewOrderBottomSheetState extends State<ViewOrderBottomSheet> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<OrdertModel>(
      builder: (_, _ordertModel, c) {
        final _order =
            _ordertModel.getOrderFromId(widget.mapOrderItems['order']);

        // * Bottom Sheet Status 1
        if (_order['status'] == 1) {
          return ViewOrderBottomSheetStatusOne(
            orderId: _order['id'],
          );
        }
        // * Bottom Sheet Status 4
        if (_order['status'] == 4) {
          return ViewOrderBottomSheetStatusFour(
            orderId: _order['id'],
          );
        }
        // * Bottom Sheet Status 5
        if (_order['status'] == 5) {
          return ViewOrderBottomSheetStatusFire(
            orderId: _order['id'],
          );
        }
        // * Bottom Sheet Status 6
        if (_order['status'] == 6) {
          return ViewOrderBottomSheetStatusSix(
            orderId: _order['id'],
          );
        }
        // * Bottom Sheet Status 7
        if (_order['status'] == 7) {
          return ViewOrderBottomSheetStatusSeven(
            orderId: _order['id'],
          );
        }
        // * Bottom Sheet Status 8
        if (_order['status'] == 8) {
          return ViewOrderBottomSheetStatusEight(
            orderId: _order['id'],
          );
        }
        return SizedBox();
      },
    );
  }
}
