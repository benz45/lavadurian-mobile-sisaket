import 'package:LavaDurian/Screens/ViewStore/components/body_edit.dart';
import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class EditStoreScreen extends StatelessWidget {
  final int storeID;
  EditStoreScreen(this.storeID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('แก้ไขร้านค้า').text.color(kTextPrimaryColor).make(),
        leading: IconButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewStoreScreen(storeID))),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: BodyEdit(storeID: storeID),
    );
  }
}
