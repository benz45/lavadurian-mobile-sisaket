import 'package:LavaDurian/Screens/ViewStore/components/body_edit.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class EditStoreScreen extends StatelessWidget {
  final int storeId;
  EditStoreScreen({this.storeId});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'แก้ไขร้านค้า',
          style: TextStyle(
              color: kTextPrimaryColor, fontSize: textTheme.subtitle1.fontSize),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_rounded),
          color: kTextPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: BodyEdit(storeID: storeId),
      ),
    );
  }
}
