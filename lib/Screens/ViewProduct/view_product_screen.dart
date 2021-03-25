import 'package:LavaDurian/Screens/EditProduct/delete_product_screen.dart';
import 'package:LavaDurian/Screens/EditProduct/edit_product_screen.dart';
import 'package:LavaDurian/Screens/ViewStore/components/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:LavaDurian/constants.dart';

class ViewProductScreen extends StatefulWidget {
  final String hero;
  final String gene;
  final String status;
  final String productId;
  const ViewProductScreen(
      {Key key, this.hero, this.status, this.gene, @required this.productId})
      : super(key: key);

  @override
  _ViewProductScreenState createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  AnimationController animateController;
  BuildContext dialogContext;

  Future<void> _showOnDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          title: Text(
            'ยืนยันการลบสินค้า',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                FlatButton(
                  minWidth: double.infinity,
                  color: kErrorColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  onPressed: () {
                    if (widget.productId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeleteProductScreen(
                            productID: int.parse(widget.productId),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                FlatButton(
                  minWidth: double.infinity,
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: kTextPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onNavigatorEditProductScreen() {
    if (widget.productId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProductScreen(
            productID: int.parse(widget.productId),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              elevation: 0,
              shadowColor: Colors.grey[50].withOpacity(0.3),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              pinned: true,
              title: Container(
                child: Flash(
                  duration: Duration(milliseconds: 450),
                  manualTrigger: true,
                  controller: (controller) => animateController = controller,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.white.withOpacity(0.2),
                          child: InkWell(
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_rounded),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ClipOval(
                            child: Material(
                              color: Colors.white.withOpacity(0.2),
                              child: InkWell(
                                child: IconButton(
                                  onPressed: _onNavigatorEditProductScreen,
                                  icon: Icon(Icons.edit),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ClipOval(
                            child: Material(
                              color: Colors.white.withOpacity(0.2),
                              child: InkWell(
                                child: IconButton(
                                  onPressed: () => _showOnDeleteDialog(),
                                  icon: Icon(Icons.delete),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              expandedHeight: 460.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: 'image${widget.hero}',
                        child: Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit
                                  .cover, //I assumed you want to occupy the entire space of the card
                              image: AssetImage(
                                'assets/images/example.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(7.5),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  "${widget.status}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                              ),
                            ),
                            Text(
                              "${widget.gene}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
