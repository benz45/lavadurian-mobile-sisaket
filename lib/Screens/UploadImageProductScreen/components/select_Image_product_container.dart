import 'package:LavaDurian/constants.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

class SelectImageProductContainer extends StatelessWidget {
  final Function onPressed;
  SelectImageProductContainer({this.onPressed});
  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.height * 0.2,
        height: size.height * 0.2,
        decoration: DottedDecoration(
          shape: Shape.box,
          borderRadius:
              BorderRadius.circular(18), //remove this to get plane rectange
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: font.headline5.fontSize,
              color: kTextSecondaryColor.withOpacity(0.3),
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              'เลือกรูปภาพ',
              style: TextStyle(color: kTextSecondaryColor.withOpacity(0.4)),
            )
          ],
        )),
      ),
    );
  }
}
