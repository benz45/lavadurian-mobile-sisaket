import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/ViewOrder/components/build_headtext.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/build_subtext.dart';
import 'package:LavaDurian/Screens/ViewOrder/components/view_order_transfer_image.dart';
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

class _ViewOrderDetailOrderState extends State<ViewOrderDetailOrder> {
  SettingModel settingModel;
  OrdertModel ordertModel;

  TextEditingController _controllerEditTransfer = TextEditingController();

  bool _isShowTextButtonOnSubmitTransfer = false;
  bool _isShowTextFieldEditTransfer = false;

  String _valueEditTransfer = "";

  Future _onsubmitConfirmEditShippingCost() async {
    try {
      final Map<String, dynamic> data = {
        "order_id": widget.orders['id'],
        "shipping": _valueEditTransfer.toString(),
      };
      // get current user token
      String token = settingModel.value['token'];

      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPoinOrderUpdateShipping}',
        body: jsonEncode(data),
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status']) {
        // set to state and notify
        ordertModel.updateOrder(
          order: jsonData['data']['order'],
        );

        Navigator.pop(context);
        setState(() {
          _isShowTextButtonOnSubmitTransfer = false;
          _isShowTextFieldEditTransfer = false;
        });

        showFlashBar(context, title: '????????????????????????????????????????????????????????????????????????????????????', message: '?????????????????????????????????????????????????????????????????????????????????????????????', success: true, duration: 3500);
      } else {
        showFlashBar(context, message: '???????????????????????????????????????????????????????????????', error: true);
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      showFlashBar(context, message: '???????????????????????????????????????????????????????????????????????????????????????????????????????????????', error: true);
    }
  }

  @override
  void initState() {
    settingModel = context.read<SettingModel>();
    ordertModel = context.read<OrdertModel>();

    super.initState();
    // shipping cost
    _controllerEditTransfer.text = widget.orders['shipping'];
    _controllerEditTransfer.selection = TextSelection.fromPosition(TextPosition(offset: _controllerEditTransfer.text.length));

    // onchange
    _controllerEditTransfer.addListener(() {
      setState(() {
        if (_isShowTextButtonOnSubmitTransfer == false) {
          _isShowTextButtonOnSubmitTransfer = true;
        }

        if (_controllerEditTransfer.text.isEmpty) {
          _isShowTextButtonOnSubmitTransfer = false;
        }

        _valueEditTransfer = _controllerEditTransfer.text;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerEditTransfer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void _onShowDialogConfirmEditTransfer() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            '??????????????????????????????????????????',
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
                  '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
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
                  onPressed: () => _onsubmitConfirmEditShippingCost(),
                  child: Text(
                    '????????????',
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(19))),
                  onPressed: () {
                    _controllerEditTransfer.text = widget.orders['shipping'];
                    Navigator.pop(context);
                  },
                  child: Text(
                    '??????????????????',
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
                  final Map _order = _ordertModel.getOrderFromId(widget.orders['id']);

                  final List _orderItem = _ordertModel.getOrderItemFromId(_order['id']);

                  final String orderDateCreate = DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(_order['date_created']).toLocal()).toString();
                  final String orderDateUpdate = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(_order['date_updated']).toLocal()).toString();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // * 1. ????????????????????????????????????????????????????????????
                      BuildHeadText(text: '????????????????????????????????????????????????????????????'),

                      BuildSubText(
                        leading: '????????????',
                        text: '${widget.orders['owner']}',
                      ),
                      BuildSubText(
                        leading: '?????????????????????',
                        text: '${_order['receive_address']}',
                        width: MediaQuery.of(context).size.width * .4,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      // * 2. ????????????????????????????????????????????????????????????
                      Divider(
                        height: size.height * 0.05,
                      ),
                      BuildSubText(
                        leading: '???????????????????????????????????????????????????',
                        text: '#${_order['id']}',
                        color: kPrimaryColor,
                      ),
                      BuildSubText(
                        leading: '?????????????????????????????????????????????',
                        text: '$orderDateCreate',
                      ),
                      if (orderDateCreate != orderDateUpdate)
                        BuildSubText(
                          leading: '????????????????????????????????????????????????????????????????????????',
                          text: '$orderDateUpdate',
                        ),
                      Divider(
                        height: size.height * 0.05,
                      ),

                      // * 3. ????????????????????????????????????????????????????????????
                      /*Edit by Phisan*/
                      if (widget.orders['status'] == 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '???????????????????????????????????????????????????????????????????????????',
                                style: TextStyle(color: kAlertColor),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isShowTextFieldEditTransfer = !_isShowTextFieldEditTransfer;
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '????????????????????????????????????',
                                    style: TextStyle(color: kPrimaryColor, fontSize: Theme.of(context).textTheme.subtitle2.fontSize),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kPrimaryColor,
                                    size: Theme.of(context).textTheme.subtitle2.fontSize,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      if (_isShowTextFieldEditTransfer)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 5),
                          decoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: TextField(
                            autofocus: true,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                            ],
                            cursorColor: kPrimaryColor,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            controller: _controllerEditTransfer,
                            decoration: InputDecoration(
                              suffix: _isShowTextButtonOnSubmitTransfer
                                  ? InkWell(
                                      onTap: () => _onShowDialogConfirmEditTransfer(),
                                      child: Text(
                                        '??????????????????',
                                        style: TextStyle(color: kPrimaryColor),
                                      ),
                                    )
                                  : Text('?????????'),
                              icon: Icon(
                                Icons.monetization_on_outlined,
                                color: kPrimaryColor,
                              ),
                              hintText: '????????????????????????',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                      if (widget.orders['status'] == 1)
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                      /*--------------*/
                      BuildSubText(
                        leading: '???????????????????????? (?????????)',
                        text: '${_order['total_order_quantity']}',
                      ),
                      BuildSubText(
                        leading: '??????????????????????????????????????????????????????????????? (??????.)',
                        text: '${_order['weight']}',
                      ),
                      BuildSubText(
                        leading: '??????????????????????????????????????? (?????????)',
                        text: '${_order['total_item_price']}',
                      ),
                      BuildSubText(
                        leading: '???????????????????????????????????? 1 ????????? (?????????)',
                        text: '${_order['box_1']}',
                      ),
                      BuildSubText(
                        leading: '???????????????????????????????????? 2 ????????? (?????????)',
                        text: '${_order['box_2']}',
                      ),
                      BuildSubText(
                        leading: '??????????????????????????? (?????????)',
                        text: '${_order['shipping']}',
                      ),
                      Divider(
                        height: 38,
                      ),
                      BuildSubText(
                        leading: '????????????????????? (?????????)',
                        fontWeight: true,
                        text: '${_order['total_order_price']}',
                        color: kPrimaryColor,
                      ),
                      /* Divider(
                        height: 28,
                      ),
                      */

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
