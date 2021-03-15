import 'package:LavaDurian/Screens/ViewOrder/view_order_screen.dart';
import 'package:LavaDurian/components/DetailOnCard.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationCardOrder extends StatelessWidget {
  final Map<String, dynamic> order;
  const OperationCardOrder({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrdertModel orderModel = context.read<OrdertModel>();
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
    var dateCreate = DateTime.parse(this.order['date_created']).toLocal();
    Map<String, String> orderStatus = orderModel.orderStatus;

    Size size = MediaQuery.of(context).size;
    final font = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewOrderScreen(
              order: order,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(18.0),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(18.0)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/example.png',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "${dateFormat.format(dateCreate)}",
                      style: TextStyle(
                        color: kTextSecondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height /
                            size.width *
                            (font.subtitle2.fontSize / 2.61),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.8, top: 2.0),
                    child: Text(
                      "${this.order['owner'].toString().length > 25 ? this.order['owner'].toString().substring(
                            0,
                            20,
                          ) + '...' : this.order['owner'].toString()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height /
                            size.width *
                            (font.subtitle1.fontSize / 2.61),
                      ),
                    ),
                  ),
                  DetailOnCard(
                    type: 'น้ำหนัก',
                    value: this.order['weight'],
                    fontSize: size.height /
                        size.width *
                        (font.subtitle1.fontSize / 2.59),
                  ),
                  DetailOnCard(
                    type: 'สถานะ',
                    value: orderStatus[this.order['status'].toString()],
                    fontSize: size.height /
                        size.width *
                        (font.subtitle1.fontSize / 2.59),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
