import 'package:flutter/material.dart';

checkStoreStatusDialog(BuildContext context) {
  // set up the buttons
  Widget confirmButton = FlatButton(
    child: Text("ตกลง"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("รอการอนุมัติ"),
    content: Text("ร้านของท่านยังรอการอนุมัติจากผู้ดูแลระบบ !"),
    actions: [
      confirmButton,
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
