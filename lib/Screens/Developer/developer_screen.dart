import 'package:LavaDurian/Screens/Signup_Account_Info/components/background.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(""),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded),
          color: kPrimaryColor,
        ),
      ),
      body: Background(
        child: Center(
          child: Container(
            height: size.height,
            width: size.width * .7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 46),
                  child: Text(
                    "ผู้พัฒนาแอพพลิเคชัน",
                    style: TextStyle(fontSize: textTheme.headline6.fontSize, color: kTextSecondaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "อาจารย์พิศาล สุขขี",
                  style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Phisan.shukkhi@gmail.com",
                    style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FaIcon(
                        FontAwesomeIcons.line,
                        color: kTextSecondaryColor,
                        size: textTheme.subtitle1.fontSize,
                      ),
                    ),
                    Text(
                      "0899697483",
                      style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FaIcon(
                        FontAwesomeIcons.phoneSquare,
                        color: kTextSecondaryColor,
                        size: textTheme.subtitle1.fontSize,
                      ),
                    ),
                    Text(
                      "084-298-2456",
                      style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                    ),
                  ],
                ),
                Divider(
                  height: 46,
                ),
                Text(
                  "วีระพันธ์ บุญุบุตร",
                  style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Benz45.th@outlook.com",
                    style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FaIcon(
                        FontAwesomeIcons.line,
                        color: kTextSecondaryColor,
                        size: textTheme.subtitle1.fontSize,
                      ),
                    ),
                    Text(
                      "benz45.th",
                      style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FaIcon(
                        FontAwesomeIcons.phoneSquare,
                        color: kTextSecondaryColor,
                        size: textTheme.subtitle1.fontSize,
                      ),
                    ),
                    Text(
                      "087-232-7359",
                      style: TextStyle(fontSize: textTheme.subtitle1.fontSize, color: kTextSecondaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
