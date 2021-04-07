import 'package:LavaDurian/Screens/AllStatusOrder/fillterd_status_order_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StatusListTile extends StatefulWidget {
  String title;
  int statusCount;
  int statusID;
  StatusListTile(this.statusID, this.title, this.statusCount);

  @override
  _StatusListTileState createState() => _StatusListTileState();
}

class _StatusListTileState extends State<StatusListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FillterdStatusOrderScreen(widget.title, widget.statusID)));
      },
      child: ListTile(
        title: Text(widget.title),
        subtitle: Text(
          'จำนวนรายการ : ${widget.statusCount}',
          style: TextStyle(color: kPrimaryColor),
        ),
        trailing: Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
