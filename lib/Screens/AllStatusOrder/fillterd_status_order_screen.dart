import 'package:LavaDurian/Screens/AllStatusOrder/components/body_fillterd.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class FillterdStatusOrderScreen extends StatelessWidget {
  String title;
  int statusID;
  FillterdStatusOrderScreen(this.title, this.statusID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('${this.title}').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: BodyFillterd(this.statusID),
      ),
    );
  }
}
