import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class BuildSubText extends StatelessWidget {
  final String leading;
  final String text;
  final double width;
  final bool fontWeight;
  final Color color;
  const BuildSubText(
      {Key key,
      this.text,
      this.leading,
      this.width,
      this.fontWeight = false,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leading,
            style: TextStyle(
                fontWeight:
                    fontWeight ?? true ? FontWeight.bold : FontWeight.normal,
                color: kTextSecondaryColor,
                fontSize: Theme.of(context).textTheme.subtitle2.fontSize),
          ),
          Container(
            width: width,
            child: Text(
              text,
              style: TextStyle(
                  color: color ?? kTextPrimaryColor,
                  fontWeight:
                      fontWeight ?? true ? FontWeight.bold : FontWeight.normal,
                  fontSize: Theme.of(context).textTheme.subtitle2.fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
