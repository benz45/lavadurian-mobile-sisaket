import 'package:LavaDurian/Screens/AllStatusOrder/components/body.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';

class AllStatusOrderScreen extends StatelessWidget {
  final storeID;
  const AllStatusOrderScreen({Key key, @required this.storeID}) : super(key: key);
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
            icon: const Icon(
              Icons.person,
              color: kTextSecondaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Body(storeID: this.storeID),
      ),
    );
  }
}
