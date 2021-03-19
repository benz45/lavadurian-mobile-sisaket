import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class OperationList extends StatelessWidget {
  final String leading;
  final String trailing;
  final onPressed;

  const OperationList({Key key, this.leading, this.trailing, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Text('$leading').text.xl.color(kTextSecondaryColor).semiBold.make(),
      trailing: TextButton(
        child: Text('$trailing').text.bold.color(kPrimaryColor).make(),
        onPressed: onPressed,
      ),
    ).pLTRB(16.0, 0.0, 8.0, 0.0);
  }
}
