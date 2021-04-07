import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class BuildHeadText extends StatelessWidget {
  final String text;
  const BuildHeadText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: TextStyle(
            color: kTextSecondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.subtitle1.fontSize),
      ),
    );
  }
}
