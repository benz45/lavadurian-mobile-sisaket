import 'package:LavaDurian/Screens/BookBankEdit/components/body_edit.dart';
import 'package:LavaDurian/Screens/BookBankEdit/components/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';

class BookBankEditScreen extends StatelessWidget {
  final bookbankID;
  const BookBankEditScreen({Key key, @required this.bookbankID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'จัดการบัญชีธนาคาร',
          style: TextStyle(
              color: kTextPrimaryColor, fontSize: textTheme.subtitle1.fontSize),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kTextSecondaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: BodyEdit(bookbankID: this.bookbankID),
      ),
      bottomNavigationBar: SizedBox(
        height: size.height * .1,
        child: Center(
          child: GestureDetector(
            onTap: () => showAlertDialog(context, this.bookbankID),
            child: Text(
              'ลบบัญชีนี้',
              style: TextStyle(color: kTextSecondaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
