import 'package:LavaDurian/Screens/EditProduct/delete_product_screen.dart';
import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, int productID) {
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DeleteProductScreen(productID: productID)));
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("ลบข้อมูลสินค้าออกจากร้านค้า"),
    content: Text("ท่านต้องการยืนยันการลบสินค้าออกจากร้านหรือไม่ ?"),
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
