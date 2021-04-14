import 'package:LavaDurian/Screens/BookBankEdit/bookbank_edit_screen.dart';
import 'package:LavaDurian/Screens/ViewStore/edit_store_screen.dart';
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

                        Divider(),
                        // * BookBank store
                        Row(
                          children: [
                            Flexible(
                              child: Consumer2<BookBankModel, StoreModel>(
                                builder: (_, bookBankModel, storeModel, __) {
                                  final int storeId =
                                      storeModel.getCurrentIdStore;
                                  final List listBookBank = bookBankModel
                                      .getBookBankFromStoreId(storeId: storeId);
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'หมายเลขบัญชี',
                                        style: TextStyle(
                                            fontSize:
                                                textTheme.subtitle2.fontSize,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: listBookBank.length,
                                        itemBuilder: (_, index) {
                                          return Container(
                                            height: 175,
                                            margin: EdgeInsets.only(bottom: 8),
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: kPrimaryColor
                                                      .withOpacity(.4)),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${bookBankModel.bank['${listBookBank[index]['bank']}']}',
                                                      style: TextStyle(
                                                          color:
                                                              kTextPrimaryColor,
                                                          fontSize: textTheme
                                                              .subtitle2
                                                              .fontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                BookBankEditScreen(
                                                                    bookbankID:
                                                                        listBookBank[index]
                                                                            [
                                                                            'id']),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        'แก้ไข',
                                                        style: TextStyle(
                                                            color:
                                                                kTextSecondaryColor,
                                                            fontSize: textTheme
                                                                .subtitle2
                                                                .fontSize,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // * Account number
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4),
                                                  child: Text(
                                                    '${listBookBank[index]['account_number']}',
                                                    style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontSize: textTheme
                                                            .subtitle1.fontSize,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                // * Account name
                                                Text(
                                                  '${listBookBank[index]['account_name']}',
                                                  style: TextStyle(
                                                      color:
                                                          kTextSecondaryColor,
                                                      fontSize: textTheme
                                                          .subtitle2.fontSize,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Divider(),
                                                // * Account branch
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'สาขา',
                                                      style: TextStyle(
                                                          color:
                                                              kTextSecondaryColor,
                                                          fontSize: textTheme
                                                              .subtitle2
                                                              .fontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${listBookBank[index]['bank_branch']}',
                                                      style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: textTheme
                                                              .subtitle2
                                                              .fontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'ประเภท',
                                                      style: TextStyle(
                                                          color:
                                                              kTextSecondaryColor,
                                                          fontSize: textTheme
                                                              .subtitle2
                                                              .fontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '${bookBankModel.type['${listBookBank[index]['account_type']}']}',
                                                      style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: textTheme
                                                              .subtitle2
                                                              .fontSize,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        Divider(),

                        // * Button edit and manage store
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "แก้ไขร้านค้า",
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
                            SizedBox(
                              width: 10,
                            ),
                            Center(
                              child: FlatButton(
                                color: kPrimaryColor.withOpacity(0.15),
                                textColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 9),
                                splashColor: kPrimaryColor.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "จัดการร้านค้า",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  // ignore: todo
                                  // TODO: Navigate to create product screen.
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
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
