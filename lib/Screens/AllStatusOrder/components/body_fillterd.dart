import 'package:LavaDurian/Screens/Operation/components/operation_card_order.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyFillterd extends StatefulWidget {
  int statusID;
  BodyFillterd(this.statusID);
  @override
  _BodyFillterdState createState() => _BodyFillterdState();
}

class _BodyFillterdState extends State<BodyFillterd> {
  int statusID;
  List<Map<String, dynamic>> orderList = [];

  OrdertModel orderModel;

  Future<String> _getOrder() async {
    try {
      if (orderList.length == 0) {
        for (var item in orderModel.orders) {
          if (item['status'] == statusID) {
            orderList.add(item);
          }
        }
      }
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    orderModel = context.read<OrdertModel>();
  }

  @override
  Widget build(BuildContext context) {
    statusID = widget.statusID;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: _getOrder(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    return OperationCardOrder(
                      order: orderList[index],
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
