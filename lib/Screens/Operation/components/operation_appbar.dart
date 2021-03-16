import 'package:LavaDurian/Screens/ViewStore/create_store_screen.dart';
import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
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
  int storeID;

  @override
  void initState() {
    super.initState();
    storeModel = context.read<StoreModel>();
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 66.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    storeID = storeModel.stores[0]['id'];
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
                padding: EdgeInsets.only(left: 0),
                child: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(Icons.menu),
                  color: kTextSecondaryColor,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.person, color: kTextSecondaryColor),
              ),
            )
          ],
        ),
      ),
      expandedHeight: 290.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 18),
          height: statusBarHeight + appBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 32.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ทุเรียนภุเขาไฟ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kTextPrimaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .fontSize),
                              ),
                              Text(
                                'จังหวัดศรีสะเกษ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kTextSecondaryColor,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .fontSize),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(right: 36.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CreateStoreScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: kPrimaryColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              'สร้างร้านค้า',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .fontSize),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Text('').text.xl2.semiBold.black.make().box.p12.make(),
              SizedBox(
                height: 28,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewStoreScreen(
                        storeID,
                      ),
                    ),
                  );
                },
                child: VxSwiper.builder(
                  itemCount: storeModel.stores.length,
                  height: 120,
                  viewportFraction: 0.71,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  isFastScrollingEnabled: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    storeID = storeModel.stores[index]['id'];
                  },
                  itemBuilder: (context, index) {
                    return "ร้าน${storeModel.stores[index]['name']}"
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
