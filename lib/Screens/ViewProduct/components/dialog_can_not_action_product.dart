import 'package:LavaDurian/Screens/ViewOrder/view_order_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialoCanNotgActionProduct extends StatelessWidget {
  final int _orderId;
  final String _title;
  final String _message;

  DialoCanNotgActionProduct(
      {@required int orderId, String title, String message})
      : this._orderId = orderId,
        this._title = title,
        this._message = message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _title ?? 'ไม่สามารถจัดการได้',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              _message ??
                  'เนื่องจากสินค้ามีคำสั่งซื้อที่ยังไม่ดำเนินการจากผู้ขาย กรุณาตรวจสอบคำสั่งซื้อ',
            ),
            SizedBox(
              height: 16,
            ),
            FlatButton(
              minWidth: double.infinity,
              color: kPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        Consumer<OrdertModel>(builder: (_, ordertModel, c) {
                      // Filter orders from id
                      final order = ordertModel.orders
                          .where((element) => element['id'] == _orderId);

                      //! Is not order data
                      if (order.isEmpty) {
                        return Scaffold(
                          body: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text('ไม่พบคำสั่งซื้อ'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'ย้อนกลับ',
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      //* Is order data
                      return ViewOrderScreen(order: order.first);
                    }),
                  ),
                );
              },
              child: Text(
                'ดูคำสั่งซื้อ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
