import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewOrderHeaderTitle extends StatelessWidget {
  const ViewOrderHeaderTitle({
    Key key,
    @required this.mapOrder,
  }) : super(key: key);

  final Map mapOrder;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    return SliverToBoxAdapter(
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
                    '#${mapOrder['id']}',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: textTheme.headline6.fontSize,
                        fontWeight: textTheme.headline6.fontWeight),
                  ),
                ],
              ),
              Consumer<StoreModel>(builder: (_, _storeModel, c) {
                return Text(
                  _storeModel.getCurrentStore[0]['name'],
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
