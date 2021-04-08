import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/ViewOrder/components/build_headtext.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/build_subtext.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

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

class _ViewOrderDetailOrderState extends State<ViewOrderDetailOrder>
    with SingleTickerProviderStateMixin {
  // * Controller text field edit weight
  TextEditingController _controllerEditWeight = TextEditingController();
  String _valueEditWeigth = "";
  bool _isShowTextFieldEditWeigth = false;
  bool _isShowTextButtonOnSubmit = false;

  @override
  void initState() {
    super.initState();
    _controllerEditWeight.text = widget.orders['weight'].toString();
    _controllerEditWeight.selection = TextSelection.fromPosition(
        TextPosition(offset: _controllerEditWeight.text.length));

    // * Listen text field edit weight
    _controllerEditWeight.addListener(() {
      setState(() {
        if (_isShowTextButtonOnSubmit == false) {
          _isShowTextButtonOnSubmit = true;
        }
        _valueEditWeigth = _controllerEditWeight.text;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerEditWeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SettingModel settingModel =
        Provider.of<SettingModel>(context, listen: false);
    OrdertModel _ordertModel = Provider.of<OrdertModel>(context, listen: false);

    Future _onSubmitConfirmOrder() async {
      try {
        Map<String, dynamic> data = {
          "order_id": widget.orders['id'].toString(),
          "weight": _valueEditWeigth
        };
        // get current user token
        String token = settingModel.value['token'];

        final response = await Http.post(
          '${settingModel.baseURL}/${settingModel.endPoinGetOrderUpdateWeight}',
          body: data,
          headers: {HttpHeaders.authorizationHeader: "Token $token"},
        );

        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonData['status']) {
          // Update order
          _ordertModel.updateOrder(jsonData['data']['order']);

          Navigator.of(context).pop();
          setState(() {
            _isShowTextFieldEditWeigth = false;
            _isShowTextButtonOnSubmit = false;
          });
          showFlashBar(context,
              title: 'ยืนยันคำสั่งซื้อแล้ว',
              message: 'ระบบกำลังแจ้งข้อมูลชำระเงินไปยังผู้ซื้อ',
              success: true,
              duration: 3500);
        } else {
          showFlashBar(context, message: 'บันทึกข้อมูลไม่สำเร็จ', error: true);
        }
      } catch (e) {
        showFlashBar(context,
            message: 'เกิดข้อผิดพลาดไม่สามารถอัพเดทน้ำหนักได้', error: true);
      }
    }

    void _onShowDialogConfirmEditWeight() {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'ยืนยันการแก้ไข',
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
                  'ระบบจะแจ้งข้อมูลการเปลี่ยนแปลงน้ำหนักไปยังผู้สั่งซื้อ',
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

                  final Map _orderItem =
                      _ordertModel.getOrderItemFromId(widget.orders['id']);

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
                        text: '#${_orderItem['order']}',
                        color: kPrimaryColor,
                      ),
                      BuildSubText(
                        leading: 'เวลาที่สั่งซื้อ',
                        text:
                            '${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(_orderItem['date_created']))}',
                      ),
                      Divider(
                        height: size.height * 0.05,
                      ),

                      // * 3. รายละเอียดคำสั่งซื้อ
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'หมายเหตุ',
                            style: TextStyle(
                                color: kTextSecondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'กรณีน้ำหนักที่มีอยู่ไม่เพียงพอ',
                                  style: TextStyle(color: kTextSecondaryColor),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isShowTextFieldEditWeigth =
                                        !_isShowTextFieldEditWeigth;
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ปรับน้ำหนัก',
                                      style: TextStyle(
                                          color: kTextSecondaryColor,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .fontSize),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: kTextSecondaryColor,
                                      size: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .fontSize,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        height: size.height * 0.05,
                      ),
                      AnimatedSize(
                        curve: Curves.easeOutQuart,
                        duration: Duration(milliseconds: 300),
                        vsync: this,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              switchInCurve: Curves.fastOutSlowIn,
                              layoutBuilder: (Widget currentChild,
                                  List<Widget> previousChildren) {
                                return Stack(
                                  children: <Widget>[
                                    ...previousChildren,
                                    if (currentChild != null) currentChild,
                                  ],
                                  alignment: Alignment.bottomCenter,
                                );
                              },
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    child: child, scale: animation);
                              },
                              duration: Duration(milliseconds: 300),
                              child: !_isShowTextFieldEditWeigth
                                  ? BuildSubText(
                                      leading: 'น้ำหนักที่สั่งซื้อ (กก.)',
                                      text: '${_order['weight']}',
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'น้ำหนักที่สั่งซื้อ (กก.)',
                                              style: TextStyle(
                                                color: kTextSecondaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 26, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: kPrimaryLightColor,
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          child: TextField(
                                            autofocus: true,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9.,]+')),
                                            ],
                                            cursorColor: kPrimaryColor,
                                            maxLines: 1,
                                            textInputAction:
                                                TextInputAction.done,
                                            controller: _controllerEditWeight,
                                            decoration: InputDecoration(
                                              suffix: _isShowTextButtonOnSubmit
                                                  ? InkWell(
                                                      onTap:
                                                          _onShowDialogConfirmEditWeight,
                                                      child: Text(
                                                        'ยืนยัน',
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColor),
                                                      ),
                                                    )
                                                  : Text('กิโลกรัม'),
                                              icon: Icon(
                                                Icons.snooze_outlined,
                                                color: kPrimaryColor,
                                              ),
                                              hintText: 'น้ำหนักที่สั่งซื้อ',
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                      ],
                                    ),
                            ),
                            BuildSubText(
                              leading: 'กิโลกรัมละ (บาท)',
                              text: '${_orderItem['price_kg']}',
                            ),
                            BuildSubText(
                              leading: 'ค่าจัดส่ง (บาท)',
                              text: '${_order['shipping']}',
                            ),
                            BuildSubText(
                              leading: 'รวมราคา (บาท)',
                              text: '${_orderItem['price']}',
                            ),
                          ],
                        ),
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
