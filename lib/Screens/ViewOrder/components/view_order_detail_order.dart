import 'package:LavaDurian/Screens/ViewOrder/components/build_headtext.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/build_subtext.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_transfer_image.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewOrderDetailOrder extends StatefulWidget {
  const ViewOrderDetailOrder({
    Key key,
    @required this.orders,
    @required this.orderItems,
  }) : super(key: key);

  final Map orders;
  final Map orderItems;

  @override
  _ViewOrderDetailOrderState createState() => _ViewOrderDetailOrderState();
}

class _ViewOrderDetailOrderState extends State<ViewOrderDetailOrder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SliverPadding(
      padding: EdgeInsets.only(top: 20),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Container(
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.04),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: size.width * 0.9,
              child: Consumer<OrdertModel>(
                builder: (_, _ordertModel, c) {
                  final Map _order =
                      _ordertModel.getOrderFromId(widget.orders['id']);

                  final List _orderItem =
                      _ordertModel.getOrderItemFromId(_order['id']);

                  final String orderDateCreate = DateFormat("dd-MM-yyyy HH:mm")
                      .format(DateTime.parse(_order['date_created']).toLocal())
                      .toString();
                  final String orderDateUpdate = DateFormat('dd-MM-yyyy HH:mm')
                      .format(DateTime.parse(_order['date_updated']).toLocal())
                      .toString();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // * 1. รายละเอียดคำสั่งซื้อ
                      BuildHeadText(text: 'รายละเอียดคำสั่งซื้อ'),

                      BuildSubText(
                        leading: 'ชื่อ',
                        text: '${widget.orders['owner']}',
                      ),
                      BuildSubText(
                        leading: 'ที่อยู่',
                        text: '${_order['receive_address']}',
                        width: MediaQuery.of(context).size.width * .4,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      // * 2. รายละเอียดคำสั่งซื้อ
                      Divider(
                        height: size.height * 0.05,
                      ),
                      BuildSubText(
                        leading: 'หมายเลยคำสั่งซื้อ',
                        text: '#${_order['id']}',
                        color: kPrimaryColor,
                      ),
                      BuildSubText(
                        leading: 'เวลาที่สั่งซื้อ',
                        text: '$orderDateCreate',
                      ),
                      if (orderDateCreate != orderDateUpdate)
                        BuildSubText(
                          leading: 'เวลาที่เปลี่ยนแปลงล่าสุด',
                          text: '$orderDateUpdate',
                        ),
                      Divider(
                        height: size.height * 0.05,
                      ),

                      // * 3. รายละเอียดคำสั่งซื้อ

                      BuildSubText(
                        leading: 'รวมจำนวน (ลูก)',
                        text: '${_order['total_order_quantity']}',
                      ),
                      BuildSubText(
                        leading: 'รวมน้ำหนักที่สั่งซื้อ (กก.)',
                        text: '${_order['weight']}',
                      ),
                      BuildSubText(
                        leading: 'ค่าทุเรียนรวม (บาท)',
                        text: '${_order['total_item_price']}',
                      ),
                      BuildSubText(
                        leading: 'ค่ากล่องขนาด 1 ลูก (บาท)',
                        text: '${_order['box_1']}',
                      ),
                      BuildSubText(
                        leading: 'ค่ากล่องขนาด 2 ลูก (บาท)',
                        text: '${_order['box_2']}',
                      ),
                      BuildSubText(
                        leading: 'รวมค่าจัดส่ง (บาท)',
                        text: '${_order['shipping']}',
                      ),
                      Divider(
                        height: 38,
                      ),
                      BuildSubText(
                        leading: 'รวมราคา (บาท)',
                        fontWeight: true,
                        text: '${_order['total_order_price']}',
                        color: kPrimaryColor,
                      ),
                      Divider(
                        height: 28,
                      ),

                      // // * Check transfer order
                      if (_order['status'] >= 5)
                        ViewOrderTransferImage(
                          orderId: _order['id'],
                        )
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
