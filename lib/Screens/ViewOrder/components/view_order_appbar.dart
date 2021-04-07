import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';

class ViewOrderAppBar extends StatelessWidget {
  const ViewOrderAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      elevation: 0,
      shadowColor: Colors.grey[50].withOpacity(0.3),
      backgroundColor: Colors.grey[50],
      automaticallyImplyLeading: false,
      leading: Container(
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_rounded),
          color: kTextPrimaryColor,
        ),
      ),
    );
  }
}
