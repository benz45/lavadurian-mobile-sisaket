import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class QRCodeDeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "ต้องการลบ QR Code !",
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
            Text("กรุณากดปุ่มยืนยันเพื่อลบภาพคิวอาร์โค๊ดออกจากร้านค้า"),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Flexible(
                  child: FlatButton(
                    minWidth: double.infinity,
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: FlatButton(
                    minWidth: double.infinity,
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
