import 'package:LavaDurian/components/rounded_input_field.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BodyEdit extends StatefulWidget {
  final int productID;
  const BodyEdit({Key key, this.productID}) : super(key: key);
  @override
  _BodyEditState createState() => _BodyEditState();
}

class _BodyEditState extends State<BodyEdit> {
  int productID;
  String _chosenGrade;
  String _chosenGene;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    productID = widget.productID;

    // Login Button
    final editButton = RoundedLoadingButton(
      child: Text(
        "แก้ไขสินค้า",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      controller: _btnController,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryColor,
      onPressed: () {},
    );

    return Padding(
      padding: EdgeInsets.all(26.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropdownButton<String>(
              value: _chosenGrade,
              isExpanded: true,
              hint: Text(
                "เกรดทุเรียน",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
              ),
              items: <String>[
                'เกรดคุณภาพ',
                'เกรดพรีเมียม',
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenGrade = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _chosenGene,
              hint: Text(
                "สายพันธุ์",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
              ),
              items: <String>[
                'ภูเขาไฟ (หมอนทอง)',
                'ก้านยาว',
                'หมอนทอง',
                'ชะนี',
                'กระดุม',
                'หลงลับแล',
                'พวงมณี'
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  _chosenGene = value;
                });
              },
            ),
          ),
          RoundedInputField(
            hintText: "จำนวนที่มีขาย (ลูก)",
            icon: Icons.add_circle_outline,
            onChanged: (v) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "ราคาต่อกิโลกรัม",
            icon: Icons.add_circle_outline,
            onChanged: (v) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "น้ำหนักเฉลี่ยต่อลูก",
            icon: Icons.add_circle_outline,
            onChanged: (v) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          RoundedInputField(
            hintText: "รายละเอียดเพิ่มเติม",
            icon: Icons.add_circle_outline,
            onChanged: (v) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            // inputFormatters: limitingTextInput,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: editButton,
          ),
        ],
      ),
    );
  }
}
