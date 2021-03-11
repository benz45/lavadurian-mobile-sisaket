import 'package:flutter/material.dart';

class BodyEdit extends StatefulWidget {
  final int productID;
  const BodyEdit({Key key, this.productID}) : super(key: key);
  @override
  _BodyEditState createState() => _BodyEditState();
}

class _BodyEditState extends State<BodyEdit> {
  int productID;
  @override
  Widget build(BuildContext context) {
    productID = widget.productID;
    return Container();
  }
}
