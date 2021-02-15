import 'package:flutter/material.dart';

class teaderTypeList extends StatefulWidget {
  @override
  _teaderTypeListState createState() => _teaderTypeListState();
}

class _teaderTypeListState extends State<teaderTypeList> {
  String dropdownValue = 'เจ้าของสวน';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>[
        'เจ้าของสวน',
        'ผู้ค้าคนกลาง',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
