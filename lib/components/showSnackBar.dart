import 'package:flutter/material.dart';

void showSnackBar(context, String text) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(text),
      action:
          SnackBarAction(label: 'ปิด', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
