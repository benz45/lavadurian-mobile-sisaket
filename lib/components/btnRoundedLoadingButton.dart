import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BtnRoundedLoadingButton extends StatelessWidget {
  final String text;
  final onPressed;
  final RoundedLoadingButtonController controller;

  BtnRoundedLoadingButton(
      {this.text, this.onPressed, @required this.controller});

  Widget build(BuildContext context) {
    return RoundedLoadingButton(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        controller: controller,
        width: MediaQuery.of(context).size.width,
        color: kPrimaryColor,
        onPressed: onPressed);
  }
}
