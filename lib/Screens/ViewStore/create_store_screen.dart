import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:LavaDurian/Screens/ViewStore/components/body_create.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('สร้างร้านค้าใหม่').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OperationScreen(),
            ),
          ),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: BodyCreate(),
      ),
    );
  }
}
