import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class DetailOnCard extends StatelessWidget {
  final String type;
  final String value;
  final double fontSize;
  const DetailOnCard({
    Key key,
    @required this.type,
    @required this.value,
    this.fontSize = 14.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$type \t",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: kTextSecondaryColor),
        ),
        Text(
          "$value",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: kPrimaryColor),
        ),
      ],
    );
  }
}
