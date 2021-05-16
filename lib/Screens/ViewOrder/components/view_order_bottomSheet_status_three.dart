import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class ViewOrderBottomSheetStatusThree extends StatefulWidget {
  const ViewOrderBottomSheetStatusThree({Key key, this.orderId}) : super(key: key);

  final int orderId;

  @override
  _ViewOrderBottomSheetStatusThreeState createState() => _ViewOrderBottomSheetStatusThreeState();
}

class _ViewOrderBottomSheetStatusThreeState extends State<ViewOrderBottomSheetStatusThree> {
  int _statusFromRadio;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    OrdertModel _ordertModel = Provider.of<OrdertModel>(context, listen: false);
    SettingModel settingModel = Provider.of<SettingModel>(context, listen: false);

    final _order = _ordertModel.getOrderFromId(widget.orderId);

    void _onSubmitConfirm(String status) async {
      try {
        Map<String, dynamic> data = {"order_id": "${_order['id']}", "status": "$_statusFromRadio"};
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
          if (_statusFromRadio > 7) {
            if (jsonData['data']['order']['status'] == 8) {
              showFlashBar(context,
                  title: 'ยกเลิกคำสั่งซื้อแล้วแล้ว', message: 'ระบบกำลังแจ้งข้อมูลการยกเลิกให้กับผู้สั่งซื้อ', success: true, duration: 3500);
            }
          } else {
            showFlashBar(context, message: 'บันทึกข้อมูลสำเร็จ', success: true);
          }
        } else {
          showFlashBar(context, message: 'บันทึกข้อมูลไม่สำเร็จ', error: true);
        }
      } catch (e) {
        showFlashBar(context, message: 'เกิดข้อผิดพลาดไม่สามารถอัพเดทสถานะคำสั่งซื้อได้', error: true);
      }
    }

    // f: Future for change  status order.
    Future _onChangeStatusOrder() async {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          // * Init state dialog only.
          int selectedRadio = _ordertModel.orderStatus.entries.map((e) => "${e.key}").toList().indexOf('${_order['status']}') ?? 0;

          return AlertDialog(
            title: Text(
              'เลือกสถานะคำสั่งซื้อ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(29),
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                return Container(
                  width: size.width * 0.8,
                  child: ListView.builder(
                    reverse: true,
                    dragStartBehavior: DragStartBehavior.start,
                    shrinkWrap: true,
                    itemCount: _ordertModel.orderStatus.entries.map((e) => e.key).toList().length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Text(
                          '${_ordertModel.orderStatus.entries.map((e) => "${e.value}").toList()[index]}'.replaceAll("", "\u{200B}"),
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: index,
                        groupValue: selectedRadio ?? 0,
                        selected: index == selectedRadio ? true : false,
                        activeColor: kPrimaryColor,
                        onChanged: index == 0 || index >= 4
                            ? (value) {
                                // * set state dialog only.
                                setDialogState(() {
                                  selectedRadio = value;
                                });

                                // * set state global only.
                                setState(() {
                                  _statusFromRadio = value + 1;
                                });
                              }
                            : null,
                      );
                    },
                  ),
                );
              },
            ),
            actionsPadding: EdgeInsets.only(bottom: 16),
            actions: [
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: OutlineButton(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(19),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // * set state global only.
                          setState(() {
                            _statusFromRadio = null;
                          });
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 36),
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(19),
                          ),
                        ),
                        onPressed: () async => _onSubmitConfirm('${selectedRadio + 1}'),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      width: size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Icon(
              Icons.timer,
              size: textTheme.headline4.fontSize,
              color: kPrimaryColor,
            ),
          ),
          Text(
            'รอการชำระเงิน',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: textTheme.subtitle1.fontSize),
          ),
          SizedBox(
            height: 18,
          ),
          TextButton(
            onPressed: _onChangeStatusOrder,
            child: Text(
              'ปรับสถานะอื่น',
              style: TextStyle(color: kPrimaryColor),
            ),
          )
        ],
      ),
    );
  }
}
