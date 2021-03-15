import 'package:LavaDurian/Screens/ViewStore/delete_store_screen.dart';
import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, int storeID) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("ยกเลิก"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("ยืนยันการลบ"),
    onPressed: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DeleteStoreScreen(storeID)));
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("ลบร้านค้าออกจากระบบ"),
    content: Text("ท่านต้องการยืนยันการร้านค้าของท่านหรือไม่ ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
