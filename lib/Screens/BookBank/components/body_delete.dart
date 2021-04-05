import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BodyDelete extends StatefulWidget {
  final bookbankID;
  const BodyDelete({Key key, @required this.bookbankID}) : super(key: key);
  @override
  _BodyDeleteState createState() => _BodyDeleteState();
}

class _BodyDeleteState extends State<BodyDelete> {
  int bookbankID;
  int storeID;
  BookBankModel bookBankModel;
  SettingModel settingModel;
  Map<String, dynamic> bookbank;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<String> _deleteBookbank() async {
    Map<String, dynamic> data = {
      'id': bookbankID.toString(),
    };

    // get current user token
    String token = settingModel.value['token'];

    try {
      final response = await Http.post(
        '${settingModel.baseURL}/${settingModel.endPoinDeleteBookBank}',
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Token $token"},
      );

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['status'] == true) {
        int index = bookBankModel.bookbank
            .indexWhere((element) => element['id'] == bookbankID);

        bookbank = bookBankModel.bookbank[index];
        storeID = bookbank['store'];
        print(storeID);

        bookBankModel.bookbank
            .removeWhere((element) => element['id'] == bookbankID);
      }
      return jsonData['message'];
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    bookBankModel = context.read<BookBankModel>();
  }

  @override
  Widget build(BuildContext context) {
    bookbankID = widget.bookbankID;
    Size size = MediaQuery.of(context).size;

    // Edit Button
    final _backButton = RoundedLoadingButton(
      child: Text(
        "กลับไปที่ร้านค้า",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        _btnController.stop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewStoreScreen(storeID)));
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
                future: _deleteBookbank(),
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
                          "ลบบัญชีธนาคารออกแล้ว",
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
