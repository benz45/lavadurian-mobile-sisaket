import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class SettingStoreScreen extends StatefulWidget {
  final int storeId;
  SettingStoreScreen({@required this.storeId});

  @override
  _SettingStoreScreenState createState() => _SettingStoreScreenState();
}

class _SettingStoreScreenState extends State<SettingStoreScreen> {
  int storeId;

  @override
  void initState() {
    super.initState();
    storeId = widget.storeId;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'ตั้งค่าร้านค้า',
          style: TextStyle(
              color: kTextPrimaryColor, fontSize: textTheme.subtitle1.fontSize),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_rounded),
          color: kTextPrimaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ! Edit store
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'แก้ไขข้อมูลร้านค้า',
                      style: TextStyle(
                          color: kTextPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Center(
                  child: OutlineButton(
                    color: kErrorColor.withOpacity(0.15),
                    borderSide: BorderSide(
                      color: kErrorColor.withOpacity(0.6),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                    splashColor: kErrorColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "ลบ",
                      style: TextStyle(
                          color: kErrorColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         EditStoreScreen(storeId: currentStore['id']),
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            // ! Remove store
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'หากต้องการลบร้านค้านี้',
                      style: TextStyle(
                          color: kErrorColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Center(
                  child: OutlineButton(
                    color: kErrorColor.withOpacity(0.15),
                    borderSide: BorderSide(
                      color: kErrorColor.withOpacity(0.6),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                    splashColor: kErrorColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "ลบ",
                      style: TextStyle(
                          color: kErrorColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         EditStoreScreen(storeId: currentStore['id']),
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
            Divider(
              color: kErrorColor,
            )
          ],
        ),
      ),
    );
  }
}
