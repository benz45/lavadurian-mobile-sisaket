import 'dart:convert';
import 'dart:io';
import 'package:LavaDurian/Screens/ViewProduct/view_product_screen.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Body extends StatefulWidget {
  final int productID;

  const Body({Key key, @required this.productID}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // ! All State
  String _chosenGene;
  String _chosenGrade;
  String _chosenStatus;
  String _productDetail;
  String _productValue;
  double _productWeight;
  double _productPrice;
  Map<String, dynamic> _product;

  // ! All Controller text field
  TextEditingController _controllerProductDetail = TextEditingController();
  TextEditingController _controllerProductValue = TextEditingController();
  TextEditingController _controllerProductWeight = TextEditingController();
  TextEditingController _controllerProductPrice = TextEditingController();

  // ! Provider
  ProductModel _productModel;
  SettingModel _settingModel;

  // ! Controller button
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _productModel = context.read<ProductModel>();
    _settingModel = context.read<SettingModel>();

    _product = _productModel.products.firstWhere((element) => element['id'] == widget.productID);

    _controllerProductDetail.text = _product['desc'].toString();
    _controllerProductValue.text = _product['values'].toString();
    _controllerProductWeight.text = _product['weight'].toString();
    _controllerProductPrice.text = _product['price'].toString();

    _controllerProductDetail.addListener(_onControllerProductDetail);
    _controllerProductValue.addListener(_onControllerProductValue);
    _controllerProductWeight.addListener(_onControllerProductWeight);
    _controllerProductPrice.addListener(_onControllerProductPrice);

    _productDetail = _product['desc'].toString();
    _productValue = _product['values'].toString();
    _productWeight = double.parse(_product['weight']);
    _productPrice = double.parse(_product['price']);
    _chosenGrade ??= _productModel.productGrade[_product['grade'].toString()];
    _chosenGene ??= _productModel.productGene[_product['gene'].toString()];
    _chosenStatus ??= _productModel.productStatus[_product['status'].toString()];
  }

  _onControllerProductDetail() {
    setState(() => _productDetail = _controllerProductDetail.text);
  }

  _onControllerProductValue() {
    setState(() => _productValue = _controllerProductValue.text);
  }

  _onControllerProductWeight() {
    double _cvProductWeight = double.parse(_controllerProductWeight.text);
    setState(() => _productWeight = _cvProductWeight);
  }

  _onControllerProductPrice() {
    double _cvProductPrice = double.parse(_controllerProductPrice.text);
    setState(() => _productPrice = _cvProductPrice);
  }

  Future<void> _onSubmit() async {
    // validate data
    if (_chosenGrade == null) {
      showFlashBar(context, message: 'กรุณาเลือกเกรดทุเรียน', warning: true);
      _btnController.reset();
      return false;
    }
    if (_chosenGene == null) {
      showFlashBar(context, message: 'กรุณาเลือกสายพันธุ์', warning: true);
      _btnController.reset();
      return false;
    }
    if (_productValue == null) {
      showFlashBar(context, message: 'กรุณากรอกจำนวนสินค้า', warning: true);
      _btnController.reset();
      return false;
    }
    if (_productPrice == null) {
      showFlashBar(context, message: 'กรุณากรอกราคาสินค้า', warning: true);
      _btnController.reset();
      return false;
    }
    if (_productWeight == null) {
      showFlashBar(context, message: 'กรุณากรอกน้ำหนักสินค้า', warning: true);
      _btnController.reset();
      return false;
    }
    if (_productDetail == null) {
      showFlashBar(context, message: 'กรุณาบรรยายรายละเอียดสินค้า', warning: true);
      _btnController.reset();
      return false;
    }
    if (_chosenStatus == null) {
      showFlashBar(context, message: 'กรุณาระบุสถานะสินค้า', warning: true);
      _btnController.reset();
      return false;
    }

    var _grade = _productModel.productGrade.keys.firstWhere((element) => _productModel.productGrade[element] == _chosenGrade, orElse: () => null);

    var _gene = _productModel.productGene.keys.firstWhere((element) => _productModel.productGene[element] == _chosenGene, orElse: () => null);

    var _status = _productModel.productStatus.keys.firstWhere((element) => _productModel.productStatus[element] == _chosenStatus, orElse: () => null);

    Map<String, dynamic> data = {
      'store_id': _product['store'].toString(),
      'product_id': _product['id'].toString(),
      'grade': _grade.toString(),
      'gene': _gene.toString(),
      'values': _productValue.toString(),
      'price': _productPrice.toString(),
      'weight': _productWeight.toString(),
      'desc': _productDetail.toString(),
      'status': _status.toString(),
    };

    // get current user token
    String token = _settingModel.value['token'];

    try {
      final response = await Http.post(
        Uri.parse('${_settingModel.baseURL}/${_settingModel.endPointEditProduct}'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        int index = _productModel.products.indexWhere((element) => element['id'] == jsonData['data']['product']['id']);
        _productModel.products[index] = jsonData['data']['product'];

        _btnController.success();
        showFlashBar(context, message: 'แก้ไขสินค้าสำเร็จ', success: true);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return ViewProductScreen(productId: widget.productID);
          }),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Edit Button
    final addButton = RoundedLoadingButton(
      child: Text(
        "บันทึกการแก้ไข",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        _onSubmit();
        _btnController.stop();
      },
    );

    Size size = MediaQuery.of(context).size;
    final double sizeSpaceHeight = size.height * 0.025;

    return Container(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.only(top: sizeSpaceHeight),
        width: size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: sizeSpaceHeight,
            ),
            // * Chosen Gene
            Row(
              children: [
                Text(
                  'สายพันธุ์',
                  style: TextStyle(
                    color: kTextSecondaryColor,
                  ),
                )
              ],
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _chosenGene,
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(
                "สายพันธุ์",
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
              ),
              items: <String>['ทุเรียนภูเขาไฟ (หมอนทอง)', 'ก้านยาว', 'หมอนทอง', 'ชะนี', 'กระดุม', 'หลงลับแล', 'พวงมณี'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenGene = value;
                });
              },
            ),
            SizedBox(
              height: sizeSpaceHeight,
            ),
            // * Chosen Grade
            Row(
              children: [
                Text(
                  'เกรดทุเรียน',
                  style: TextStyle(
                    color: kTextSecondaryColor,
                  ),
                )
              ],
            ),
            DropdownButton<String>(
              value: _chosenGrade,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(
                "เกรดทุเรียน",
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
              ),
              items: <String>[
                'เกรดคุณภาพ',
                'เกรดพรีเมี่ยม',
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenGrade = value;
                });
              },
            ),
            SizedBox(
              height: sizeSpaceHeight,
            ),

            // * Chosen Status
            Row(
              children: [
                Text(
                  'สถานะการขาย',
                  style: TextStyle(
                    color: kTextSecondaryColor,
                  ),
                )
              ],
            ),
            DropdownButton<String>(
              value: _chosenStatus,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              hint: Text(
                "สถานะการขาย",
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
              ),
              items: <String>[
                'พร้อมขาย',
                'สั่งจองล่วงหน้า',
                'ยุติการขาย',
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenStatus = value;
                });
              },
            ),
            SizedBox(
              height: sizeSpaceHeight,
            ),

            SizedBox(
              height: sizeSpaceHeight,
            ),

            // * Product Detail
            Row(
              children: [
                Text(
                  'รายละเอียดเกี่ยวกับสินค้า',
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
                cursorColor: kPrimaryColor,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                controller: _controllerProductDetail,
                decoration: InputDecoration(
                  hintText: 'รายละเอียดเกี่ยวกับสินค้า',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: sizeSpaceHeight,
            ),
            // * Product Value
            Row(
              children: [
                Text(
                  'จำนวนที่มีขาย (ลูก)',
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
                cursorColor: kPrimaryColor,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                controller: _controllerProductValue,
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  suffix: Text('ลูก'),
                  icon: Icon(
                    Icons.drag_indicator_outlined,
                    color: kPrimaryColor,
                  ),
                  hintText: 'จำนวนที่มีขาย (ลูก)',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: sizeSpaceHeight,
            ),

            // * Product Weight
            Row(
              children: [
                Text(
                  'น้ำหนักเฉลี่ยต่อลูก',
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                ],
                cursorColor: kPrimaryColor,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                controller: _controllerProductWeight,
                decoration: InputDecoration(
                  suffix: Text('กิโลกรัม'),
                  icon: Icon(
                    Icons.snooze_outlined,
                    color: kPrimaryColor,
                  ),
                  hintText: 'น้ำหนักเฉลี่ยต่อลูก',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: sizeSpaceHeight,
            ),

            // * Product Price
            Row(
              children: [
                Text(
                  'ราคาต่อกิโลกรัม',
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
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                cursorColor: kPrimaryColor,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                controller: _controllerProductPrice,
                decoration: InputDecoration(
                  suffix: Text('บาท'),
                  icon: Icon(
                    Icons.money,
                    color: kPrimaryColor,
                  ),
                  hintText: 'ราคาต่อกิโลกรัม',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: sizeSpaceHeight,
            ),
            addButton,
            SizedBox(
              height: sizeSpaceHeight * 4,
            ),
          ],
        ),
      ),
    );
  }
}
