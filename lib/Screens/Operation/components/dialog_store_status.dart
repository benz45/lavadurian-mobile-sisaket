import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class checkStoreStatusDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "รอการอนุมัติ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("ร้านของท่านยังรอการอนุมัติจากผู้ดูแลระบบ !"),
            SizedBox(
              height: 16,
            ),
            FlatButton(
              minWidth: double.infinity,
              color: kPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ตกลง',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
