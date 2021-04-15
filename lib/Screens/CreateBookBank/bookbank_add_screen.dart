import 'package:LavaDurian/Screens/BookBank/components/body_add.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class BookBankAddScreen extends StatelessWidget {
  final storeID;
  const BookBankAddScreen({Key key, @required this.storeID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('เพิ่มบัญชีธนาคาร').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: BodyAdd(storeID: this.storeID),
      ),
    );
  }
}
