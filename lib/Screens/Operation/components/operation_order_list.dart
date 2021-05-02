import 'package:LavaDurian/Screens/Operation/components/operation_card_order.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationOrderList extends StatefulWidget {
  final int maxlength;
  const OperationOrderList({Key key, this.maxlength}) : super(key: key);

  @override
  _OperationOrderListState createState() => _OperationOrderListState();
}

class _OperationOrderListState extends State<OperationOrderList> {
  OrdertModel orderModel;
  StoreModel storeModel;

  @override
  void initState() {
    super.initState();
    orderModel = context.read<OrdertModel>();
    storeModel = context.read<StoreModel>();
  }

  Widget buildList() {
    // * set order list
    var orders = orderModel.orders
        .where((element) => element['store'] == storeModel.getCurrentIdStore)
        .toList();

    return Consumer<OrdertModel>(
      builder: (_, orderModel, c) {
        if (orderModel.orders != null && orderModel.orders.length != 0) {
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
        }
        return SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildList();
  }
}
