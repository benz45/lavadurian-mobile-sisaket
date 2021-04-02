import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color textColor;
  final Color disabledColor;
  final bool enabled;

  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.enabled,
    this.disabledColor = kDisabledPrimaryColor,
    this.textColor = Colors.white,
    Color color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          disabledColor: disabledColor,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
          color: kPrimaryColor,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
