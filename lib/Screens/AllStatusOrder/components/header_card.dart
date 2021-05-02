import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreHeader extends StatelessWidget {
  final title;
  const StoreHeader({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    String statusTile = "";
    if (this.title != null) {
      statusTile = this.title;
    } else {
      statusTile = "ทุกรายการ";
    }

    return Container(
      child: Center(
        child: Container(
          width: size.width * 0.9,
          margin: EdgeInsets.only(bottom: size.height * 0.028),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'รายการคำสั่งซื้อ',
                    style: textTheme.headline6,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '#${statusTile}',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: textTheme.headline6.fontSize,
                        fontWeight: textTheme.headline6.fontWeight),
                  ),
                ],
              ),
              Consumer<StoreModel>(builder: (_, _storeModel, c) {
                return Text(
                  _storeModel?.getCurrentStore['name'],
                  style: TextStyle(
                      color: kTextSecondaryColor, fontWeight: FontWeight.bold),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
