import 'package:LavaDurian/Screens/ViewStore/create_store_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class OperationAppBarHeaderBarModalBottomSheet extends StatelessWidget {
  const OperationAppBarHeaderBarModalBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 22, 18),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ร้านค้า',
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateStoreScreen(),
                  ),
                );
              },
              child: Center(
                child: Text(
                  "สร้างร้านค้า",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
