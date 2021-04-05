import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class OperationList extends StatelessWidget {
  final Key _key;
  final String _leading;
  final Widget _trailing;

  OperationList({Key key, String leading, Widget trailing, Function onPressed})
      : this._key = key,
        this._leading = leading,
        this._trailing = trailing;

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      key: _key,
      leading: Text(
        '$_leading',
        style: TextStyle(
          color: kTextSecondaryColor,
          fontSize: font.subtitle1.fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: _trailing,
    );
  }
}
