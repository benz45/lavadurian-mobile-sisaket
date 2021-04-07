import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class ViewOrderBottomSheetStatusFour extends StatelessWidget {
  const ViewOrderBottomSheetStatusFour({Key key, this.orderId})
      : super(key: key);

  final int orderId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    OrdertModel _ordertModel = Provider.of<OrdertModel>(context, listen: false);
    SettingModel settingModel =
        Provider.of<SettingModel>(context, listen: false);

    final _orderItem = _ordertModel.getOrderItemFromId(orderId);

    Future _onSubmitConfirmPayment() async {
      try {
        Map<String, dynamic> data = {
          "order_id": _orderItem['order'].toString(),
          "status": "5"
        };
        // get current user token
        String token = settingModel.value['token'];

        final response = await Http.post(
          '${settingModel.baseURL}/${settingModel.endPoinOrderStatusUpdate}',
          body: data,
          headers: {HttpHeaders.authorizationHeader: "Token $token"},
        );

        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonData['status']) {
          // Update order
          _ordertModel.updateOrder(jsonData['data']['order']);
          Navigator.of(context).pop();
          showFlashBar(context,
              title: 'ยืนยันชำระเงินแล้ว',
              message:
                  'กรุณาจัดส่งสินค้าตามคำสั่งซื้อ และเปลี่ยนสถานะเมื่อจัดส่งเรียบร้อยแล้ว',
              success: true,
              duration: 3500);
        } else {
          showFlashBar(context, message: 'บันทึกข้อมูลไม่สำเร็จ', error: true);
        }
      } catch (e) {
        showFlashBar(context,
            message: 'เกิดข้อผิดพลาดไม่สามารถอัพเดทสถานะคำสั่งซื้อได้',
            error: true);
      }
    }

    void _onShowDialogConfirmPayment() {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'ยืนยันชำระเงินแล้ว',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'ระบบจะแจ้งข้อมูลการยืนยันชำระเงินให้กับผู้สั่งซื้อ และปรับสถานะคำสั่งซื้อเป็น "ชำระเงินแล้ว"',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minWidth: double.infinity,
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(19),
                    ),
                  ),
                  onPressed: _onSubmitConfirmPayment,
                  child: Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                FlatButton(
                  minWidth: double.infinity,
                  color: Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(19))),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: kTextPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      width: size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            size: textTheme.headline4.fontSize,
            color: kPrimaryColor,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'ขณะนี้ผู้สั่งซื้อได้ทำการแจ้งชำระเงินเรียบร้อยแล้ว กรุณายืนยันการชำระเงิน',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: textTheme.subtitle1.fontSize),
          ),
          SizedBox(
            height: 18,
          ),
          FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
            onPressed: () => _onShowDialogConfirmPayment(),
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              child: Text(
                'ยืนยันชำระเงินแล้ว',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textTheme.subtitle1.fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
