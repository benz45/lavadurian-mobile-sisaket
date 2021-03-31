import 'package:LavaDurian/Screens/ViewOrder/view_order_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialoCanNotgDeleteProduct extends StatelessWidget {
  final orderId;
  DialoCanNotgDeleteProduct({this.orderId});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'ไม่สามารถลบสินค้าได้',
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
                          .where((element) => element['id'] == orderId);

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
