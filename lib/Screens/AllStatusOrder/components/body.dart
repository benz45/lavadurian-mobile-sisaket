import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/AllStatusOrder/components/status_list.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_card_order.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class Body extends StatefulWidget {
  final storeID;

  const Body({Key key, @required this.storeID}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  SettingModel settingModel;
  OrdertModel orderModel;
  int storeID;

  Future<String> _getOrderStatus() async {
    String token = settingModel.value['token'];
    try {
      Map<String, dynamic> data = {'store': 1.toString()};

      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPoinGetOrderStatus}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );
      var jsonData = json.decode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        // convert json data to list
        List<Map<String, dynamic>> orderItem = [];
        for (var item in jsonData['data']['orders']) {
          orderItem.add(item);
        }

        //! Set state
        orderModel.orders = orderItem;
        orderModel.statusCount = jsonData['data']['status'];

        return jsonData['message'];
      } else {
        return '101';
      }
    } catch (e) {
      print(e.toString());
    }
    return "101";
  }

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    orderModel = context.read<OrdertModel>();
  }

  @override
  Widget build(BuildContext context) {
    storeID = widget.storeID;
    return FutureBuilder(
      future: _getOrderStatus(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  StatusCard(),
                  SizedBox(height: 20),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orderModel.orders.length,
                    itemBuilder: (context, index) {
                      return OperationCardOrder(
                        order: orderModel.orders[index],
                      );
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}
