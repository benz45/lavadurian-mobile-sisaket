import 'package:flutter/material.dart';
import 'package:LavaDurian/components/text_field_container.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/services.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final onChanged;
  final keyboardType;
  final inputFormatters;
  final controller;
  final onSubmitted;
  final textInputAction;
  final bool enabled;
  final bool autofocus;
  final obscureText;
  final maxLines;
  final textAlignVertical;
  final textAlign;

  const RoundedInputField(
      {Key key,
      this.autofocus = false,
      this.enabled,
      this.hintText,
      this.icon,
      this.controller,
      this.onChanged,
      this.onSubmitted,
      this.obscureText = false,
      this.inputFormatters,
      this.textInputAction,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.textAlign,
      this.textAlignVertical})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        key: key,
        autocorrect: false,
        enableSuggestions: false,
        autofocus: autofocus,
        enabled: enabled,
        inputFormatters: inputFormatters,
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: kPrimaryColor,
        textInputAction: textInputAction,
        maxLines: maxLines,
        textAlignVertical: textAlignVertical,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          icon: icon != null
              ? Icon(
                  icon,
                  color: kPrimaryColor,
                )
              : null,
          hintText: hintText,
          border: InputBorder.none,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
