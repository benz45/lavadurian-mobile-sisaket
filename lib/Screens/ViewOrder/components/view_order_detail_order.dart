import 'package:LavaDurian/Screens/ViewOrder/components/build_headtext.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/build_subtext.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewOrderDetailOrder extends StatelessWidget {
  const ViewOrderDetailOrder({
    Key key,
    @required this.orders,
    @required this.orderItems,
  }) : super(key: key);

  final Map orders;
  final Map orderItems;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // * 1. รายละเอียดคำสั่งซื้อ
                BuildHeadText(text: 'รายละเอียดคำสั่งซื้อ'),
                BuildSubText(
                  leading: 'ชื่อ',
                  text: '${orders['owner']}',
                ),
                BuildSubText(
                  leading: 'ที่อยู่',
                  text: '${orders['receive_address']}',
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
                  text: '#${orderItems['order']}',
                  color: kPrimaryColor,
                ),
                BuildSubText(
                  leading: 'เวลาสั่งซื้อ',
                  text:
                      '${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(orderItems['date_created']))}',
                ),
                Divider(
                  height: size.height * 0.05,
                ),

                // * 3. รายละเอียดคำสั่งซื้อ
                BuildSubText(
                  leading: 'น้ำหนักที่สั่งซื้อ (กก.)',
                  text: '${orderItems['weight']}',
                ),
                BuildSubText(
                  leading: 'กิโลกรัมละ (บาท)',
                  text: '${orderItems['price_kg']}',
                ),
                BuildSubText(
                  leading: 'ค่าจัดส่ง (บาท)',
                  text: '${orders['shipping']}',
                ),
                BuildSubText(
                  leading: 'รวมราคา (บาท)',
                  text: '${orderItems['price']}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
