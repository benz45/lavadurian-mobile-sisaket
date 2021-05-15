import 'package:LavaDurian/Screens/ViewOrder/components/build_headtext.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';

class ViewOrderManageStatus extends StatelessWidget {
  const ViewOrderManageStatus({
    Key key,
    @required this.mapOrder,
  }) : super(key: key);
  final Map mapOrder;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          children: [
            Container(
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
                  final _order = _ordertModel.getOrderFromId(mapOrder['id']);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // * Box status header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'สถานะคำสั่งซื้อ',
                            style: TextStyle(color: kTextSecondaryColor, fontSize: textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),
                          ),
                          if (_order['status'] != 8)
                            Row(
                              children: [
                                Text(
                                  'ขั้นตอนที่',
                                  style: TextStyle(color: kTextSecondaryColor, fontSize: textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '${_order['status']}/7',
                                  style: TextStyle(color: kPrimaryColor, fontSize: textTheme.subtitle1.fontSize, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 26, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              '${_ordertModel.orderStatus['${_order['status']}']}',
                              style: TextStyle(fontSize: textTheme.subtitle1.fontSize + 4, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconStepper(
                            stepReachedAnimationEffect: Curves.fastOutSlowIn,
                            stepColor: kTextSecondaryColor.withOpacity(0.15),
                            nextButtonIcon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: textTheme.subtitle1.fontSize,
                              color: kTextSecondaryColor,
                            ),
                            enableNextPreviousButtons: false,
                            steppingEnabled: false,
                            scrollingDisabled: false,
                            lineDotRadius: 1.5,
                            previousButtonIcon: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: textTheme.subtitle1.fontSize,
                              color: kTextSecondaryColor,
                            ),
                            activeStepBorderColor: _order['status'] == 8 ? Colors.red[300] : kPrimaryColor.withOpacity(0.75),
                            activeStepColor: _order['status'] == 8 ? Colors.red[300] : kPrimaryColor.withOpacity(0.75),
                            lineColor: kTextSecondaryColor.withOpacity(0.25),
                            icons: _order['status'] != 8
                                ? [
                                    // * status 1
                                    Icon(
                                      Icons.access_time_sharp,
                                      color: Colors.white,
                                    ),
                                    // * status 2
                                    Icon(
                                      Icons.flag_outlined,
                                      color: Colors.white,
                                    ),
                                    // * status 3
                                    Icon(
                                      Icons.timer,
                                      color: Colors.white,
                                    ),
                                    // * status 4
                                    Icon(
                                      Icons.mark_chat_read_outlined,
                                      color: Colors.white,
                                    ),
                                    // * status 5
                                    Icon(
                                      Icons.mobile_friendly,
                                      color: Colors.white,
                                    ),
                                    // * status 6
                                    Icon(
                                      Icons.delivery_dining,
                                      color: Colors.white,
                                    ),

                                    // * status 7
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                    ),
                                  ]
                                : [
                                    // * status 8
                                    Icon(
                                      Icons.remove_circle_outline_sharp,
                                      color: Colors.white,
                                    ),
                                  ],
                            activeStep: _order['status'] != 8 ? _order['status'] - 1 : 0,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Container(
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
              child: Consumer<OrdertModel>(builder: (_, _orderModel, c) {
                final _order = _orderModel.getOrderFromId(mapOrder['id']);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          BuildHeadText(text: 'คำแนะนำ'),

                          // * รอการชำระเงิน
                          if (_order['status'] == 1)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ผู้ขายสามารถปรับจำนวน และนำหนักของสินค้าในคำสั่งซื้อได้ เพื่อให้ตรงกับความป็นจริงในการจัดส่ง"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("ให้ยืนยันคำสั่งซื้อนี้ เพื่อดำเนินการต่อ"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("จากนั้นผู้ซื้อจึงจะสามารถโอนเงินได้"),
                              ],
                            )
                          // * รอการชำระเงิน
                          else if (_order['status'] == 3)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ผู้ซื้อสินค้าสามารถดำเนินการโอนเงินได้ในสถานะนี้"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("ผู้ขายกรุณารอเพื่อตรวจสอบการโอนเงิน"),
                              ],
                            )
                          // * ชำระเงินแล้ว
                          else if (_order['status'] == 5)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ผู้ซื้อสินค้าได้แจ้งชำระเงินแล้ว"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("ผู้ขายกรุณาตรวจสอบและจัดส่งสินค้าตามรายการ"),
                              ],
                            )
                          // * ยกเลิก
                          else if (_order['status'] == 8)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("รายการคำสั่งซื้อนี้ถูกยกเลิกออกจากระบบ"),
                              ],
                            )
                          // * จัดส่งสินค้า
                          else if (_order['status'] > 5 && _order['status'] < 8)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("กรุณาติดตามความพึงพอใจในสินค้าและบริการจากผู้ซื้อ"),
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
