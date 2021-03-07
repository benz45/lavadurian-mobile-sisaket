import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class CardOrder extends StatelessWidget {
  final Map<String, dynamic> order;
  const CardOrder({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrdertModel orderModel = context.read<OrdertModel>();
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
    var dateCreate = DateTime.parse(this.order['date_created']).toLocal();
    Map<String, String> orderStatus = orderModel.orderStatus;

    return Card(
        elevation: 0.42,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(13.5))),
                height: 100,
                width: 100,
                child: Text('รูปภาพ').centered(),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.41,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${dateFormat.format(dateCreate)}')
                            .text
                            .extraBold
                            .make(),
                        Text('${this.order['owner'].toString().length > 25 ? this.order['owner'].toString().substring(
                                  0,
                                  20,
                                ) + '...' : this.order['owner'].toString()}')
                            .text
                            .extraBold
                            .make()
                            .pOnly(bottom: 8.0),
                        Text('น้ำหนัก: ${this.order['weight']} กก.\n'
                            'สถานะ: ${orderStatus[this.order['status'].toString()]}'),
                      ],
                    )).wFull(context),
                    // Container(
                    //     child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [Text('ดูรายการสั่งซื้อ').text.bold.make()],
                    // )).wFull(context).pOnly(right: 4.0),
                  ],
                ),
              ).pOnly(left: 16)
            ],
          ),
        ));
  }
}
