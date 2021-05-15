import 'package:flutter/material.dart';

// Colors Content.
const kBackgroundColor = Color(0xFFF4F8FE);
const kPrimaryColor = Color(0xFF4D9F30);
// const kPrimaryColor = Color(0xFF639C44);
// const kPrimaryColor = Color(0xFF558b2f);
const kDisabledPrimaryColor = Color(0xDFE3EE);
const kPrimaryLightColor = Color(0xFFeceff1);
const kErrorColor = Color(0xFFEF5350);
// const kPrimaryColor = Color(0xFF005cae);
// const kDisabledPrimaryColor = Color(0xDFE3EE);
// const kPrimaryLightColor = Color(0xFFdfe1ee);

// Colors Text.
const kTextPrimaryColor = Colors.black;
const kTextSecondaryColor = Colors.black54;

// * TextButton Style
final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
  primary: Colors.white,
  backgroundColor: kPrimaryColor,
  side: BorderSide(color: kPrimaryColor, width: 1),
  minimumSize: Size(double.infinity, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);
