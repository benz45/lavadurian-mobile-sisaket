import 'package:LavaDurian/Screens/AllStatusOrder/components/header_card.dart';
import 'package:LavaDurian/Screens/AllStatusOrder/components/status_list.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final storeID;

  const Body({Key key, @required this.storeID}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String currentStoreById;
  int storeID;
  Size size;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeID = widget.storeID;
    size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StoreHeader(),
            StatusCard(),
          ],
        ),
      ),
    );
  }
}
