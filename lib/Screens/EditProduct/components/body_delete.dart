import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BodyDelete extends StatefulWidget {
  final int productID;
  const BodyDelete({Key key, this.productID}) : super(key: key);
  @override
  _BodyDeleteState createState() => _BodyDeleteState();
}

class _BodyDeleteState extends State<BodyDelete> {
  ProductModel productModel;
  SettingModel settingModel;

  List<Map<String, dynamic>> products;
  Map<String, dynamic> product;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<String> _deleteProduct() async {
    Map<String, dynamic> data = {
      'id': product['id'].toString(),
    };

    // get current user token
    String token = settingModel.value['token'];
    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPointDeleteProduct}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        // Remove product from list
        products.removeWhere((element) => element['id'] == product['id']);
        // update state
        productModel.products = products;
        return jsonData.toString();
      } else {
        return 'fail';
      }
    } catch (e) {
      print(e);
      return 'fail';
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
    Size size = MediaQuery.of(context).size;
    products = productModel.products;
    if (products != null) {
      product =
          products.firstWhere((element) => element['id'] == widget.productID);
    }

    // Edit Button
    final _backButton = RoundedLoadingButton(
      child: Text(
        "????????????????????????????????????????????????",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        _btnController.stop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => OperationScreen()));
      },
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: FutureBuilder(
                future: _deleteProduct(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.03),
                        SvgPicture.asset(
                          "assets/icons/undraw_order_confirmed_aaw7.svg",
                          height: size.height * 0.30,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          "???????????????????????????????????????????????????????????????????????????",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: _backButton,
                        )
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
