// Header title on
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class OperationAppHeaderMenu extends StatelessWidget {
  const OperationAppHeaderMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 0),
              child: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu),
                color: kTextSecondaryColor,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.person, color: kTextSecondaryColor),
            ),
          )
        ],
      ),
    );
  }
}
