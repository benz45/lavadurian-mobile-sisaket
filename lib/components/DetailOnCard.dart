import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class DetailOnCard extends StatelessWidget {
  final String type;
  final String value;
  final double fontSize;
  final Color color;
  const DetailOnCard({
    Key key,
    @required this.type,
    @required this.value,
    this.color,
    this.fontSize = 14.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FittedBox(
          child: Text(
            "$type \t",
            style: TextStyle(fontWeight: FontWeight.bold, color: kTextSecondaryColor),
          ),
        ),
        FittedBox(
          child: Text(
            "$value",
            style: TextStyle(fontWeight: FontWeight.bold, color: color ?? kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
