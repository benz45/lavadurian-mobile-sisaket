import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
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
  final int productID;

  const Body({Key key, @required this.productID}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _chosenGrade;
  String _chosenGene;
  String _chosenStatus;

  int _productValue;
  double _productPrice;
  double _productWeight;
  String _productDetail;

  TextEditingController _controllerProductValue;
  TextEditingController _controllerProductPrice;
  TextEditingController _controllerProductWeight;
  TextEditingController _controllerProductDetail;

  List<Map<String, dynamic>> products;
  Map<String, dynamic> product;

  ProductModel productModel;
  SettingModel settingModel;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<void> _onSubmit() async {
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
      'store_id': product['store'].toString(),
      'product_id': product['id'].toString(),
      'grade': _grade.toString(),
      'gene': _gene.toString(),
      'values': _productValue.toString(),
      'price': _productPrice.toString(),
      'weight': _productWeight.toString(),
      'desc': _productDetail,
      'status': _status.toString(),
    };

    // get current user token
    String token = settingModel.value['token'];

    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPointEditProduct}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        int index = products.indexWhere(
            (element) => element['id'] == jsonData['data']['product']['id']);

        products[index] = jsonData['data']['product'];

        // update state
        productModel.products = products;

        _btnController.success();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewStoreScreen(jsonData['data']['product']['store'])));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    productModel = context.read<ProductModel>();
    settingModel = context.read<SettingModel>();
  }

  @override
  Widget build(BuildContext context) {
    products = productModel.products;
    product =
        products.firstWhere((element) => element['id'] == widget.productID);

    _controllerProductValue =
        TextEditingController(text: product['values'].toString());

    _controllerProductWeight =
        TextEditingController(text: product['weight'].toString());

    _controllerProductPrice =
        TextEditingController(text: product['price'].toString());

    _controllerProductDetail = TextEditingController(text: product['desc']);

    _productValue = product['values'];
    _productWeight = double.parse(product['weight']);
    _productPrice = double.parse(product['price']);
    _productDetail = product['desc'];

    if (_chosenGrade == null) {
      _chosenGrade = productModel.productGrade[product['grade'].toString()];
    }

    if (_chosenGene == null) {
      _chosenGene = productModel.productGene[product['gene'].toString()];
    }

    if (_chosenStatus == null) {
      _chosenStatus = productModel.productStatus[product['status'].toString()];
    }

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
            onChanged: (v) {
              _productValue = int.parse(v);
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: _controllerProductValue,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "ราคาต่อกิโลกรัม",
            icon: Icons.add_circle_outline,
            onChanged: (v) {
              _productPrice = double.parse(v);
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: _controllerProductPrice,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "น้ำหนักเฉลี่ยต่อลูก",
            icon: Icons.add_circle_outline,
            onChanged: (v) {
              _productWeight = double.parse(v);
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: _controllerProductWeight,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "รายละเอียดเพิ่มเติม",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _productDetail = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            controller: _controllerProductDetail,
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
            child: addButton,
          ),
        ],
      ),
    );
  }
}
