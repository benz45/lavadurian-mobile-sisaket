import 'package:LavaDurian/Screens/AllStatusOrder/components/body_fillterd.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';

class FillterdStatusOrderScreen extends StatelessWidget {
  final String title;
  final int statusID;
  FillterdStatusOrderScreen(this.title, this.statusID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.person,
                color: kTextSecondaryColor,
              ),
              onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        child: BodyFillterd(this.statusID, this.title),
      ),
    );
  }
}
