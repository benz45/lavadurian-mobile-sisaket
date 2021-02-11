import 'dart:io';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  SettingModel settingModel;
  @override
  void initState() {
    super.initState();
    settingModel = context.read<SettingModel>();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset My Password'),
      ),
      body: WebView(
        initialUrl:
            '${settingModel.baseURL}/${settingModel.endPointResetPassword}?device=mobile',
      ),
    );
  }
}
