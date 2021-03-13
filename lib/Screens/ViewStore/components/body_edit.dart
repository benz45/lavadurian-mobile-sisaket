import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BodyEdit extends StatefulWidget {
  final int storeID;

  const BodyEdit({Key key, @required this.storeID}) : super(key: key);
  @override
  _BodyEditState createState() => _BodyEditState();
}

class _BodyEditState extends State<BodyEdit> {
  String _chosenDistrict;
  String _sloganValue;
  String _phone1Value;
  String _phone2Value;
  String _aboutValue;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    // Edit Button
    final submitButton = RoundedLoadingButton(
      child: Text(
        "สร้างร้านค้า",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {
        _btnController.stop();
      },
    );

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _chosenDistrict,
              isExpanded: true,
              hint: Text(
                "เขตอำเภอ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
              ),
              items: <String>['กันทรลักษณ์', 'ขุนหาญ', 'ศรีรัตนะ']
                  .map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenDistrict = value;
                });
              },
            ),
          ),
          RoundedInputField(
            hintText: "สโลแกนร้านค้า",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _sloganValue = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เบอร์โทรติดต่อหลัก",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _phone1Value = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เบอร์โทรติดต่อสำรอง (ถ้ามี)",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _phone2Value = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "เกี่ยวกับร้านค้า",
            icon: Icons.add_circle_outline,
            onChanged: (v) => _aboutValue = v,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: submitButton,
          )
        ],
      ),
    );
  }
}
