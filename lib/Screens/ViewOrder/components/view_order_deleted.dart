import 'package:LavaDurian/Screens/Operation/operation_screen.dart';
import 'package:flutter/material.dart';

class ViewOrderDeleted extends StatelessWidget {
  const ViewOrderDeleted({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Text('สินค้าของผู้ขายถูกลบไปแล้ว'),
          ),
          OutlineButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OperationScreen(),
                ),
              );
            },
            child: Text('ย้อนกลับ'),
          )
        ],
      ),
    );
  }
}
