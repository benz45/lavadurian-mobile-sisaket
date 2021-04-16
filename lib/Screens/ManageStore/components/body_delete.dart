import 'dart:convert';
import 'dart:io';
import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BodyDelete extends StatefulWidget {
  final int storeID;
  const BodyDelete({Key key, @required this.storeID}) : super(key: key);
  @override
  _BodyDeleteState createState() => _BodyDeleteState();
}

class _BodyDeleteState extends State<BodyDelete> {
  int storeID;
  StoreModel storeModel;
  SettingModel settingModel;
  UserModel userModel;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    storeModel = context.read<StoreModel>();
    settingModel = context.read<SettingModel>();
    userModel = context.read<UserModel>();
  }

  Future<String> _deleteStore() async {
    List<Map<String, dynamic>> stores = storeModel.getStores;
    int index = stores.indexWhere((element) => element['id'] == storeID);
    Map<String, dynamic> store = stores[index];

    // get current user token
    String token = settingModel.value['token'];

    Map<String, dynamic> data = {
      'id': store['id'].toString(),
    };

    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPoinDeleteStore}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        stores.removeWhere((element) => element['id'] == store['id']);
        storeModel.onRemoveCurrentStore(
            id: storeID, userId: userModel.value['id']);
        // update state
        storeModel.setStores = stores;
        return "success";
      } else {
        return "fail";
      }
    } catch (e) {
      print(e);
      return "fail";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (storeID == null) {
      storeID = widget.storeID;
    }

    // Edit Button
    final _backButton = RoundedLoadingButton(
      child: Text(
        "กลับไปที่หน้าหลัก",
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
                future: _deleteStore(),
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
                          "ลบร้านค้าแล้วออกจากระบบแล้ว",
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
