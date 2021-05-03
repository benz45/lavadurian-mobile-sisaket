import 'package:LavaDurian/Screens/EditStore/edit_store_screen.dart';
import 'package:LavaDurian/Screens/Operation/components/card_bookbank.dart';
import 'package:LavaDurian/Screens/Operation/components/card_social_qrcode.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationPageFour extends StatelessWidget {
  const OperationPageFour({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Consumer<StoreModel>(
          builder: (_, storeModel, __) {
            final Map currentStore = storeModel.getCurrentStore;
            return Column(
              children: [
                // ! Card container
                Container(
                  padding: EdgeInsets.all(22),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.04),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  width: size.width * 0.9,
                  child: SingleChildScrollView(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        // * Icon store
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Icon(
                            Icons.storefront_rounded,
                            size: textTheme.headline3.fontSize,
                          ),
                        ),

                        // * Name store
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${currentStore['name']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: textTheme.subtitle1.fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        Text(
                          '${currentStore['slogan']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kTextSecondaryColor,
                              fontSize: textTheme.subtitle2.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),

                        // * Edit store button
                        SizedBox(
                          width: double.infinity,
                          child: OutlineButton(
                            color: kPrimaryColor.withOpacity(0.15),
                            borderSide: BorderSide(
                              color: kPrimaryColor.withOpacity(0.6),
                            ),
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 9),
                            splashColor: kPrimaryColor.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "แก้ไขหรือตั้งค่าร้านค้า",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditStoreScreen(
                                      storeId: currentStore['id']),
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 8,
                        ),
                        // * About store
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'คำอธิบายเพิ่มเติม',
                                    style: TextStyle(
                                        fontSize: textTheme.subtitle2.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '${currentStore['about']}',
                                    style: TextStyle(
                                        color: kTextSecondaryColor,
                                        fontSize: textTheme.subtitle2.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),

                        // * Phone store
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'เบอร์โทร',
                                    style: TextStyle(
                                        fontSize: textTheme.subtitle2.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${currentStore['phone1']}',
                                        style: TextStyle(
                                            color: kTextSecondaryColor,
                                            fontSize:
                                                textTheme.subtitle2.fontSize,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (currentStore['phone2'] != '' ||
                                          currentStore['phone2'] != null)
                                        Text(
                                          ', ${currentStore['phone2']}',
                                          style: TextStyle(
                                              color: kTextSecondaryColor,
                                              fontSize:
                                                  textTheme.subtitle2.fontSize,
                                              fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                CardBookBank(),
                SizedBox(
                  height: 16,
                ),
                CardSocialQRCode(),
              ],
            );
          },
        ),
        SizedBox(
          height: size.height * .4,
        )
      ],
    );
  }
}
