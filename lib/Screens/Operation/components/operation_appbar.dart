import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

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
    final font = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;

    storeID = storeModel.stores[0]['id'];
    return SliverAppBar(
      shadowColor: Colors.grey[50].withOpacity(0.5),
      backgroundColor: Colors.grey[50],
      automaticallyImplyLeading: false,
      pinned: true,
      title: HeaderTitle(),
      expandedHeight: 130.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 0),
          height: statusBarHeight + appBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showBarModalBottomSheet(
                              expand: false,
                              enableDrag: true,
                              context: context,
                              bounce: true,
                              backgroundColor: Colors.white,
                              builder: (context) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.48,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 18, 22, 18),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'ร้านค้า',
                                                  style: TextStyle(
                                                      fontSize:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headline6
                                                              .fontSize,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Center(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .add_circle_outline_sharp,
                                                          color: kPrimaryColor,
                                                          size:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .fontSize,
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "สร้างร้านค้า",
                                                          style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontSize: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .subtitle1
                                                                .fontSize,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: storeModel.stores.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                leading: Icon(
                                                    Icons.storefront_rounded),
                                                title: Text(
                                                  '${storeModel.stores[index]['name']}'
                                                      .replaceAll(
                                                          "", "\u{200B}"),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                trailing: TextButton(
                                                  child: Text(
                                                    'ตั้งค่า',
                                                    style: TextStyle(
                                                        color: kPrimaryColor),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            ViewStoreScreen(
                                                          storeID,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Positioned(
                                  //   bottom: size.height * 0.05,
                                  //   child: GestureDetector(
                                  //     onTap: () {},
                                  //     child: Center(
                                  //       child: Row(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.center,
                                  //         children: [
                                  //           Icon(
                                  //             Icons.add_circle_outline_sharp,
                                  //             color: kPrimaryColor,
                                  //           ),
                                  //           SizedBox(
                                  //             width: 8,
                                  //           ),
                                  //           Text(
                                  //             "สร้างร้านของคุณ",
                                  //             style: TextStyle(
                                  //                 color: kPrimaryColor,
                                  //                 fontSize: Theme.of(context)
                                  //                     .textTheme
                                  //                     .subtitle1
                                  //                     .fontSize,
                                  //                 fontWeight: FontWeight.bold),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                          child: Container(
                            width: size.width * 0.8,
                            child: LayoutBuilder(
                              builder: (context, constaints) {
                                // Build the textspan
                                final text = TextSpan(
                                  text: '${storeModel.stores[0]['name']}'
                                      .replaceAll("", "\u{200B}"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kTextPrimaryColor,
                                    fontSize: size.height /
                                        size.width *
                                        (font.headline4.fontSize / 3.31),
                                  ),
                                );

                                // Use a textpainter to determine if it will exceed max lines
                                final textPainter = TextPainter(
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    textDirection: TextDirection.ltr,
                                    text: text);

                                // trigger it to layout
                                textPainter.layout(
                                    minWidth: constaints.minWidth,
                                    maxWidth: constaints.maxWidth);

                                // whether the text overflowed or not
                                bool exceeded = textPainter.didExceedMaxLines;

                                return Row(
                                  children: [
                                    exceeded
                                        ? Container(
                                            width: size.width * 0.7,
                                            child: Text.rich(
                                              text,
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        : Container(
                                            child: Text.rich(
                                              text,
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .fontSize,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            'ทุเรียนภุเขาไฟจังหวัดศรีสะเกษ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextSecondaryColor,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .fontSize),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
