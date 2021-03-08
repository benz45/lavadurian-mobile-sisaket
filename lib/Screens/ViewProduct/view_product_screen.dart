import 'package:LavaDurian/Screens/ViewProduct/components/body.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewProductScreen extends StatelessWidget {
  final String hero;
  ViewProductScreen({this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: Hero(
        tag: '$hero',
        child: Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit
                  .cover, //I assumed you want to occupy the entire space of the card
              image: AssetImage(
                'assets/images/example.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
