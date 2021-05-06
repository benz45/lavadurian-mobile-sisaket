import 'package:LavaDurian/Screens/AllStatusOrder/components/status_listtile.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusCard extends StatefulWidget {
  @override
  _StatusCardState createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  OrdertModel orderModel;
  StoreModel storeModel;

  int getStatusCount(int statusNumber) {
    var data = orderModel.statusCount.where((element) => element['store'] == storeModel.getCurrentIdStore).toList();
    if (data[0]['$statusNumber'] != null) {
      return data[0]['$statusNumber'];
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    storeModel = context.read<StoreModel>();
    orderModel = context.read<OrdertModel>();
  }

  @override
  Widget build(BuildContext context) {
    var tiles = [
      StatusListTile(1, orderModel.orderStatus['1'], getStatusCount(1)),
      StatusListTile(2, orderModel.orderStatus['2'], getStatusCount(2)),
      StatusListTile(3, orderModel.orderStatus['3'], getStatusCount(3)),
      StatusListTile(4, orderModel.orderStatus['4'], getStatusCount(4)),
      StatusListTile(5, orderModel.orderStatus['5'], getStatusCount(5)),
      StatusListTile(6, orderModel.orderStatus['6'], getStatusCount(6)),
      StatusListTile(7, orderModel.orderStatus['7'], getStatusCount(7)),
      StatusListTile(8, orderModel.orderStatus['8'], getStatusCount(8)),
    ];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: <Widget>[
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: ListTile.divideTiles(context: context, tiles: tiles).toList(),
          )
        ],
      ),
    );
  }
}
