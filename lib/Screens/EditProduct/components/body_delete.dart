import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BodyDelete extends StatefulWidget {
  final int productID;
  const BodyDelete({Key key, @required this.productID}) : super(key: key);
  @override
  _BodyDeleteState createState() => _BodyDeleteState();
}

class _BodyDeleteState extends State<BodyDelete> {
  Future<String> _deleteProduct() async {
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: FutureBuilder(
              future: _deleteProduct(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.03),
                      SvgPicture.asset(
                        "assets/icons/undraw_order_confirmed_aaw7.svg",
                        height: size.height * 0.30,
                      ),
                      SizedBox(height: size.height * 0.03),
                      Text(
                        "ลบสินค้าออกจากร้านค้าแล้ว",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26),
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
