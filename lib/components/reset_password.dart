import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';

class ResetPasswordCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const ResetPasswordCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'ลืมรหัสผ่าน ? ',
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            'รีเซ็ตรหัสผ่าน',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
