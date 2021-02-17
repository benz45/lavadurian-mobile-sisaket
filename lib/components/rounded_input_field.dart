import 'package:flutter/material.dart';
import 'package:LavaDurian/components/text_field_container.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/services.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final keyboardType;
  final inputFormatters;
  final controller;
  final onSubmitted;
  final textInputAction;

  const RoundedInputField(
      {Key key,
      this.hintText,
      this.icon,
      this.controller,
      this.onChanged,
      this.onSubmitted,
      this.inputFormatters,
      this.textInputAction,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        inputFormatters: inputFormatters,
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: kPrimaryColor,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
