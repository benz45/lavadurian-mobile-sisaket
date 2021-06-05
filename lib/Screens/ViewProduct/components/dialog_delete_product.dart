import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/components/showSnackBar.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class DialogDeleteProduct extends StatelessWidget {
  final int _productId;
  DialogDeleteProduct({@required int productId}) : this._productId = productId;

  @override
  Widget build(BuildContext context) {
    SettingModel settingModel = Provider.of<SettingModel>(context);
    ProductModel productModel = Provider.of<ProductModel>(context);
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    void _onDeleteProduct() async {
      try {
        Map<String, dynamic> data = {
          'id': _productId.toString(),
        };

        // get current user token
        String token = settingModel.value['token'];
        final response = await Http.post(
          Uri.parse('${settingModel.baseURL}/${settingModel.endPointDeleteProduct}'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: "Token $token"},
        );

        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        //* Delete product success
        if (jsonData['status'] == true) {
          // Remove product from list
          productModel.removeProduct(productId: _productId);

          showFlashBar(context, message: 'ลบสินค้าสำเร็จ', success: true);
          // * Navigate operation screen and show snackbar delete product success
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (_) {
              return Scaffold(
                key: _scaffoldKey,
                body: OperationScreen(),
              );
            },
          ), (Route<dynamic> route) => false);
        } else {
          AlertDialog(
            title: Text(
              'ลบสินค้าไม่สำเร็จ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [Text('กรุณาลองใหม่อีกครั้ง')],
              ),
            ),
          );
        }
      } catch (err) {
        print(err);
      }
    }

    return AlertDialog(
      title: Text(
        'ยืนยันการลบสินค้า',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            FlatButton(
              minWidth: double.infinity,
              color: kErrorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              onPressed: _onDeleteProduct,
              child: Text(
                'ตกลง',
                style: TextStyle(color: Colors.white),
              ),
            ),
            FlatButton(
              minWidth: double.infinity,
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: kTextPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
