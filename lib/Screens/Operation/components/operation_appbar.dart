import 'package:LavaDurian/Screens/Operation/components/operation_appbar_header_menu.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_appbar_headerbar_model_bottom_sheet.dart';
import 'package:LavaDurian/Screens/Operation/components/operation_appbar_select_store.dart';
// import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
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
  int storeID;

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = 66.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final font = Theme.of(context).textTheme;
    StoreModel storeModel = Provider.of<StoreModel>(context);
    final currentStore = storeModel.getCurrentStore;
    Size size = MediaQuery.of(context).size;

    storeID = storeModel.getCurrentIdStore;
    return SliverAppBar(
      shadowColor: Colors.grey[50].withOpacity(0.5),
      backgroundColor: Colors.grey[50],
      automaticallyImplyLeading: false,
      pinned: true,
      title: OperationAppHeaderMenu(),
      expandedHeight: 142.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.fromLTRB(0, statusBarHeight, 0, 0),
          height: statusBarHeight + appBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 10),
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
                                        OperationAppBarHeaderBarModalBottomSheet(),
                                        OperationAppBarSelectStore(),
                                      ],
                                    ),
                                  ),
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
                                  text: '${currentStore[0]['name']}'
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
