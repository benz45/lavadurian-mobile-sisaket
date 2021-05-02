import 'package:LavaDurian/Screens/AllStatusOrder/components/header_card.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_card_order.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BodyFillterd extends StatefulWidget {
  final int statusID;
  final String title;

  BodyFillterd(this.statusID, this.title);

  @override
  _BodyFillterdState createState() => _BodyFillterdState();
}

class _BodyFillterdState extends State<BodyFillterd> {
  int statusID;
  List<Map<String, dynamic>> orderList = [];

  OrdertModel orderModel;
  StoreModel storeModel;

  Future<String> _getOrder() async {
    try {
      if (orderList.length == 0) {
        int storeID = storeModel.getCurrentIdStore;
        for (var item in orderModel.orders) {
          if (item['status'] == statusID && item['store'] == storeID) {
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
    storeModel = context.read<StoreModel>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    statusID = widget.statusID;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: _getOrder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return orderList.length != 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StoreHeader(title: widget.title),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderList.length,
                          itemBuilder: (context, index) {
                            return OperationCardOrder(
                              orderId: orderList[index]['id'],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Container(
                      height: size.height * .5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StoreHeader(title: widget.title),
                          SizedBox(height: size.height * 0.03),
                          SvgPicture.asset(
                            "assets/icons/undraw_order_confirmed_aaw7.svg",
                            height: size.height * 0.30,
                          ),
                          SizedBox(height: size.height * 0.03),
                          Text(
                            "ยังไม่มีออร์เดอร์ในสถานะนี้",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
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
    );
  }
}
