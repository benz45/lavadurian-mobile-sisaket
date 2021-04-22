import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class ViewOrderBottomSheetStatusOne extends StatelessWidget {
  const ViewOrderBottomSheetStatusOne({Key key, this.orderId})
      : super(key: key);

  final int orderId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    OrdertModel _ordertModel = Provider.of<OrdertModel>(context, listen: false);
    SettingModel settingModel =
        Provider.of<SettingModel>(context, listen: false);

    final _order = _ordertModel.getOrderFromId(orderId);

    Future _onSubmitConfirmOrder() async {
      try {
        Map<String, dynamic> data = {
          "order_id": "${_order['id']}",
          "status": "3"
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
          _ordertModel.updateOrder(order: jsonData['data']['order']);
          Navigator.of(context).pop();
          showFlashBar(context,
              title: 'ยืนยันคำสั่งซื้อแล้ว',
              message: 'ระบบกำลังแจ้งข้อมูลชำระเงินไปยังผู้ซื้อ',
              success: true,
              duration: 3500);
        } else {
          showFlashBar(context, message: 'บันทึกข้อมูลไม่สำเร็จ', error: true);
        }
      } catch (e) {
        print(e);
        showFlashBar(context,
            message: 'เกิดข้อผิดพลาดไม่สามารถอัพเดทสถานะคำสั่งซื้อได้',
            error: true);
      }
    }

    void _onShowDialogConfirmOrder() {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'ยืนยันคำสั่งซื้อนี้',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(29),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'ระบบจะแจ้งข้อมูลชำระเงินไปยังผู้สั่งซื้อ และปรับสถานะคำสั่งซื้อเป็น "รอการชำระเงิน" เพื่อรอการชำระเงินจากผู้สั่งซื้อ',
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
                  onPressed: _onSubmitConfirmOrder,
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'น้ำหนักรวม',
                  style: TextStyle(
                      color: kTextSecondaryColor,
                      fontSize: textTheme.subtitle2.fontSize),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  '${_order['weight']} กก.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontSize: textTheme.subtitle2.fontSize),
                ),
              ],
            ),
            Text(
              '${_order['total_order_price']} บาท',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: textTheme.headline6.fontSize),
            ),
          ],
        ),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          onPressed: () => _onShowDialogConfirmOrder(),
          color: kPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            child: Text(
              'ยืนยันคำสั่งซื้อนี้',
              style: TextStyle(
                  color: Colors.white, fontSize: textTheme.subtitle1.fontSize),
            ),
          ),
        ),
      ],
    );
  }
}
