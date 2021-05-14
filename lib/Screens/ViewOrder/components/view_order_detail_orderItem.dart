import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/ViewOrder/components/build_subtext.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class ViewOrderDetailOrderItem extends StatefulWidget {
  const ViewOrderDetailOrderItem({
    Key key,
    @required this.order,
    @required this.orderItems,
  }) : super(key: key);

  final Map order;
  final Map orderItems;

  @override
  _ViewOrderDetailOrderItemState createState() => _ViewOrderDetailOrderItemState();
}

class _ViewOrderDetailOrderItemState extends State<ViewOrderDetailOrderItem> with TickerProviderStateMixin {
  TextEditingController _controllerEditWeight = TextEditingController();
  String _valueEditWeigth = "";
  bool _isShowTextFieldEditWeigth = false;
  bool _isShowTextButtonOnSubmit = false;
  @override
  void initState() {
    super.initState();

    _controllerEditWeight.text = widget.orderItems['weight'];
    _controllerEditWeight.selection = TextSelection.fromPosition(TextPosition(offset: _controllerEditWeight.text.length));

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
    SettingModel settingModel = Provider.of<SettingModel>(context, listen: false);
    OrdertModel _ordertModel = Provider.of<OrdertModel>(context, listen: false);

    Future _onSubmitConfirmEditWeightOrder() async {
      try {
        final Map<String, dynamic> data = {"order_id": widget.order['id'], "item_id": "${widget.orderItems['id']}", "weight": "$_valueEditWeigth"};
        // get current user token
        String token = settingModel.value['token'];

        final response = await Http.post(
          '${settingModel.baseURL}/${settingModel.endPoinGetOrderUpdateWeight}',
          body: jsonEncode(data),
          headers: {
            HttpHeaders.authorizationHeader: "Token $token",
            HttpHeaders.contentTypeHeader: "application/json",
          },
        );

        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonData['status']) {
          // Update order
          _ordertModel.updateOrder(order: jsonData['data']['order'], orderItem: jsonData['data']['orderItems']);

          Navigator.of(context).pop();
          setState(() {
            _isShowTextFieldEditWeigth = false;
            _isShowTextButtonOnSubmit = false;
          });

          showFlashBar(context, title: 'แก้ไขน้ำหนักสินค้าเรียบร้อย', message: 'ระบบกำลังแจ้งข้อมูลไปยังผู้ซื้อ', success: true, duration: 3500);
        } else {
          showFlashBar(context, message: 'บันทึกข้อมูลไม่สำเร็จ', error: true);
        }
      } catch (e) {
        print(e);
        showFlashBar(context, message: 'เกิดข้อผิดพลาดไม่สามารถอัพเดทน้ำหนักได้', error: true);
      }
    }

    void _onShowDialogConfirmEditWeight() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                  onPressed: _onSubmitConfirmEditWeightOrder,
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(19))),
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

    return ListView(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        if (widget.order['status'] == 1)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'หมายเหตุ',
                style: TextStyle(color: kTextSecondaryColor, fontWeight: FontWeight.bold),
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
                        _isShowTextFieldEditWeigth = !_isShowTextFieldEditWeigth;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ปรับน้ำหนัก',
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
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
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
                layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
                  return Stack(
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                    alignment: Alignment.bottomCenter,
                  );
                },
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                duration: Duration(milliseconds: 300),
                child: !_isShowTextFieldEditWeigth
                    ? BuildSubText(
                        leading: 'น้ำหนักที่สั่งซื้อ (กก.)',
                        text: '${widget.orderItems['weight']}',
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
                              controller: _controllerEditWeight,
                              decoration: InputDecoration(
                                suffix: _isShowTextButtonOnSubmit
                                    ? InkWell(
                                        onTap: _onShowDialogConfirmEditWeight,
                                        child: Text(
                                          'ยืนยัน',
                                          style: TextStyle(color: kPrimaryColor),
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
                leading: 'จำนวน (ลูก)',
                text: '${widget.orderItems['quantity']}',
              ),
              Consumer<ProductModel>(builder: (_, _productModel, __) {
                return BuildSubText(
                  leading: 'น้ำหนัก/ลูก (กก.)',
                  text: '${_productModel.getProductWeightFromId(productId: widget.orderItems['product'])}',
                );
              }),
              BuildSubText(
                leading: 'ราคา/กก. (บาท)',
                text: '${widget.orderItems['price_kg']}',
              ),
              BuildSubText(
                leading: 'น้ำหนักรวม (กก.)',
                text: '${widget.orderItems['weight']}',
              ),
              BuildSubText(
                leading: 'ราคารวม (บาท)',
                color: kPrimaryColor,
                fontWeight: true,
                text: '${widget.orderItems['price']}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
