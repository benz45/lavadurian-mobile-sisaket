import 'package:LavaDurian/Screens/BookBank/components/body_delete.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class BookbankDeleteScreen extends StatelessWidget {
  final bookbankID;

  const BookbankDeleteScreen({Key key, @required this.bookbankID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('ลบบัญชีธนาคาร').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: BodyDelete(bookbankID: this.bookbankID),
      ),
    );
  }
}
