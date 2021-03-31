import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class DialogDeleteProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'ยืนยันการลบสินค้า',
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
            FlatButton(
              minWidth: double.infinity,
              color: kErrorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              onPressed: () {
                // TODO: Tuture delete product
                // if (widget.productId != null) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => DeleteProductScreen(
                //         productID: widget.productId,
                //       ),
                //     ),
                //   );
                // }
              },
              child: Text(
                'ตกลง',
                style: TextStyle(color: Colors.white),
              ),
            ),
            FlatButton(
              minWidth: double.infinity,
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: kTextPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
