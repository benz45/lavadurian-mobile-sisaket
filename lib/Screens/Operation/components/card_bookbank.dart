import 'package:LavaDurian/Screens/BookBankEdit/bookbank_edit_screen.dart';
import 'package:LavaDurian/Screens/CreateBookBank/bookbank_add_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardBookBank extends StatelessWidget {
  const CardBookBank({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.04),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
      width: size.width * 0.9,
      child: // BookBank store
          Row(
        children: [
          Flexible(
            child: Consumer2<BookBankModel, StoreModel>(
              builder: (_, bookBankModel, storeModel, __) {
                final int storeId = storeModel.getCurrentIdStore;
                List listBookBank =
                    bookBankModel.getBookBankFromStoreId(storeId: storeId);
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'หมายเลขบัญชี',
                      style: TextStyle(
                          fontSize: textTheme.subtitle2.fontSize,
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
                                width: 2, color: kPrimaryColor.withOpacity(.4)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //!  Account bank
                                  Flexible(
                                    child: Text(
                                      '${bookBankModel.bank['${listBookBank[index]['bank']}']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: kTextPrimaryColor,
                                          fontSize:
                                              textTheme.subtitle2.fontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookBankEditScreen(
                                              bookbankID: listBookBank[index]
                                                  ['id']),
                                        ),
                                      );
                                    },
                                    // * Edit button
                                    child: Text(
                                      'แก้ไข',
                                      style: TextStyle(
                                          color: kTextSecondaryColor,
                                          fontSize:
                                              textTheme.subtitle2.fontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              //!  Account number
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '${listBookBank[index]['account_number']}',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: textTheme.subtitle1.fontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              //  Account name
                              Text(
                                '${listBookBank[index]['account_name']}',
                                style: TextStyle(
                                    color: kTextSecondaryColor,
                                    fontSize: textTheme.subtitle2.fontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(),
                              //! Account branch
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'สาขา',
                                    style: TextStyle(
                                        color: kTextSecondaryColor,
                                        fontSize: textTheme.subtitle2.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${listBookBank[index]['bank_branch']}',
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: textTheme.subtitle2.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              //! Account type
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ประเภท',
                                    style: TextStyle(
                                        color: kTextSecondaryColor,
                                        fontSize: textTheme.subtitle2.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${bookBankModel.type['${listBookBank[index]['account_type']}']}',
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: textTheme.subtitle2.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Center(
                      child: OutlineButton(
                        color: kPrimaryColor.withOpacity(0),
                        borderSide: BorderSide(
                          width: 0,
                          color: kPrimaryColor.withOpacity(0),
                        ),
                        highlightedBorderColor: kPrimaryColor.withOpacity(0.2),
                        textColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                        splashColor: kPrimaryColor.withOpacity(0.2),
                        highlightColor: kPrimaryColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: kPrimaryColor,
                            ),
                            Text(
                              "เพิ่มหมายเลขบัญชี",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookBankAddScreen(storeID: storeId),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
