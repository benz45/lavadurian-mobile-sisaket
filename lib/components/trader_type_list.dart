import 'package:flutter/material.dart';

class TeaderTypeList extends StatefulWidget {
  @override
  _TeaderTypeListState createState() => _TeaderTypeListState();
}

class _TeaderTypeListState extends State<TeaderTypeList> {
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
