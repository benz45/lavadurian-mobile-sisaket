import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class OperationAppBar extends StatefulWidget {
  @override
  _OperationAppBarState createState() => _OperationAppBarState();
}

class _OperationAppBarState extends State<OperationAppBar> {
  StoreModel storeModel;

  @override
  void initState() {
    super.initState();
    storeModel = context.read<StoreModel>();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 66.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      shadowColor: Colors.grey[50].withOpacity(0.3),
      backgroundColor: Colors.grey[50],
      automaticallyImplyLeading: false,
      pinned: true,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(Icons.menu),
                  color: kPrimaryColor,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.person, color: kPrimaryColor),
              ),
            )
          ],
        ),
      ),
      expandedHeight: 260.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.grey[50],
          padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 30),
          height: statusBarHeight + appBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('ร้านค้า').text.xl2.semiBold.black.make().box.p12.make(),
              VxSwiper.builder(
                itemCount: storeModel.stores.length,
                height: 130,
                viewportFraction: 0.55,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                isFastScrollingEnabled: false,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return "${storeModel.stores[index]['name']}"
                      .text
                      .black
                      .make()
                      .box
                      .rounded
                      .alignCenter
                      .color(kPrimaryLightColor)
                      .make()
                      .p4();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
