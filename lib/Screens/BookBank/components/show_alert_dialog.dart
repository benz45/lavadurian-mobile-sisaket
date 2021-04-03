import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, int bookbankID) {
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
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => DeleteStoreScreen(storeID)));
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("ลบบัญชีออกจากระบบ"),
    content: Text("ท่านต้องการยืนยันการลบบัญชีของท่านหรือไม่ ?"),
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
