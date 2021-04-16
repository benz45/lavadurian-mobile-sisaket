import 'dart:convert';
import 'dart:io';
import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Body extends StatefulWidget {
  final int storeID;

  const Body({Key key, @required this.storeID}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int storeID;
  String _chosenGrade;
  String _chosenGene;
  String _chosenStatus;
  int _productValue;
  int _productPrice;
  double _productWeight;
  String _productDetail;

  SettingModel settingModel;
  ProductModel productModel;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<void> _createProduct() async {
    // validate data
    if (_chosenGrade == null) {
      showSnackBar(context, 'กรุณาเลือกเกรดทุเรียน');
      _btnController.reset();
      return false;
    }
    if (_chosenGene == null) {
      showSnackBar(context, 'กรุณาเลือกสายพันธุ์');
      _btnController.reset();
      return false;
    }
    if (_productValue == null) {
      showSnackBar(context, 'กรุณากรอกจำนวนสินค้า');
      _btnController.reset();
      return false;
    }
    if (_productPrice == null) {
      showSnackBar(context, 'กรุณากรอกราคาสินค้า');
      _btnController.reset();
      return false;
    }
    if (_productWeight == null) {
      showSnackBar(context, 'กรุณากรอกน้ำหนักสินค้า');
      _btnController.reset();
      return false;
    }
    if (_productDetail == null) {
      showSnackBar(context, 'กรุณาบรรยายรายละเอียดสินค้า');
      _btnController.reset();
      return false;
    }

    if (_chosenStatus == null) {
      showSnackBar(context, 'กรุณาเลือกสถานะการขาย');
      _btnController.reset();
      return false;
    }

    // get current user token
    String token = settingModel.value['token'];

    var _grade = productModel.productGrade.keys.firstWhere(
        (element) => productModel.productGrade[element] == _chosenGrade,
        orElse: () => null);

    var _gene = productModel.productGene.keys.firstWhere(
        (element) => productModel.productGene[element] == _chosenGene,
        orElse: () => null);

    var _status = productModel.productStatus.keys.firstWhere(
        (element) => productModel.productStatus[element] == _chosenStatus,
        orElse: () => null);

    Map<String, dynamic> data = {
      'store_id': storeID.toString(),
      'grade': _grade.toString(),
      'gene': _gene.toString(),
      'values': _productValue.toString(),
      'price': _productPrice.toString(),
      'weight': _productWeight.toString(),
      'desc': _productDetail,
      'status': _status.toString(),
    };

    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPointAddProduct}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status']) {
        // Set new product to list
        List<Map<String, dynamic>> products = productModel.products;
        products.add(jsonData['data']['product']);

        // update state
        productModel.products = products;

        _btnController.success();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OperationScreen()));
      } else {
        _btnController.reset();
        showSnackBar(context, 'บันทึกข้อมูลไม่สำเร็จ');
      }
    } on Exception catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    productModel = context.read<ProductModel>();
  }

  @override
  Widget build(BuildContext context) {
    storeID = widget.storeID;

    // Edit Button
    final editButton = RoundedLoadingButton(
      child: Text(
        "สร้างสินค้าใหม่",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        _createProduct();
        // _btnController.stop();
      },
    );

    return Padding(
      padding: EdgeInsets.all(26.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropdownButton<String>(
              value: _chosenGrade,
              isExpanded: true,
              hint: Text(
                "เกรดทุเรียน",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _chosenGene,
              hint: Text(
                "สายพันธุ์",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
              ),
              items: <String>[
                'ทุเรียนภูเขาไฟ (หมอนทอง)',
                'ก้านยาว',
                'หมอนทอง',
                'ชะนี',
                'กระดุม',
                'หลงลับแล',
                'พวงมณี'
              ].map((String value) {
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
          ),
          RoundedInputField(
            hintText: "จำนวนที่มีขาย (ลูก)",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _productValue = int.parse(v),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "ราคาต่อกิโลกรัม",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _productPrice = int.parse(v),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "น้ำหนักเฉลี่ยต่อลูก",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _productWeight = double.parse(v),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "รายละเอียดเพิ่มเติม",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _productDetail = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            // inputFormatters: limitingTextInput,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropdownButton<String>(
              value: _chosenStatus,
              isExpanded: true,
              hint: Text(
                "สถานะการขาย",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
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
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: editButton,
          ),
        ],
      ),
    );
  }
}
