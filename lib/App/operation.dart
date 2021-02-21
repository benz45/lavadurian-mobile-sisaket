import 'dart:convert';
import 'dart:io';

import 'package:LavaDurian/Screens/Login/components/background.dart';
import 'package:LavaDurian/components/drawer_menu.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as Http;

class OperationPage extends StatefulWidget {
  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  SettingModel settingModel;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    userModel = context.read<UserModel>();
  }

  Future<String> _getUserProfile() async {
    String token = settingModel.value['token'];

    if (userModel.value.isEmpty) {
      print("Connect...");
      final response = await Http.get(
          '${settingModel.baseURL}/${settingModel.endPointUserProfile}',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Token $token"
          });

      var jsonData = json.decode(utf8.decode(response.bodyBytes));

      for (var item in jsonData['results']) {
        userModel.value = {
          'url': item['url'],
          'id': item['id'],
          'username': item['username'],
          'first_name': item['first_name'],
          'last_name': item['last_name'],
          'email': item['email'],
        };
      }
      return response.body;
    } else {
      return userModel.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lava Durian Online'),
        // automaticallyImplyLeading: false,
      ),
      drawer: NavDrawer(),
      body: Background(
        child: FutureBuilder(
          future: _getUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "${userModel.value['first_name']} ${userModel.value['last_name']}"),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
