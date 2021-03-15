import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';
import 'package:provider/provider.dart';

class ViewOrderScreen extends StatefulWidget {
  final order;
  const ViewOrderScreen({Key key, this.order}) : super(key: key);

  @override
  _ViewOrderScreenState createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  AnimationController animateController;

  @override
  Widget build(BuildContext context) {
    // Provider
    final orderItems = Provider.of<OrdertModel>(context).orderItems;
    final product = Provider.of<ProductModel>(context);

    // Media Query
    final double appBarHeight = 66.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Filter index id on orderItems id.
    final Map mapOrderItems = Map<String, dynamic>.from(
        orderItems.where((e) => e['id'] == widget.order['id']).single);

    // Filter product id on the mapOrderItems id.
    final Map mapProduct = Map<String, dynamic>.from(product.products
        .where((e) => e['id'] == mapOrderItems['product'])
        .single);

    // Filter product gene.
    final String mapProductGene = product.productGene['${mapProduct['gene']}'];

    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              elevation: 0,
              shadowColor: Colors.grey[50].withOpacity(0.3),
              backgroundColor: Colors.white,
              pinned: true,
              expandedHeight: 280.0,
              automaticallyImplyLeading: false,
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back_rounded),
                          color: kTextPrimaryColor,
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.more_vert, color: kTextPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: statusBarHeight + appBarHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18.0)),
                                  image: DecorationImage(
                                    fit: BoxFit
                                        .cover, //I assumed you want to occupy the entire space of the card
                                    image: AssetImage(
                                      'assets/images/example.png',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 17.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$mapProductGene',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kTextPrimaryColor,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .fontSize),
                                    ),
                                    Text(
                                      '${mapProduct['price']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .fontSize),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'น้ำหนัก',
                                      style:
                                          TextStyle(color: kTextPrimaryColor),
                                    ),
                                    Text(
                                      '${mapProduct['weight']}',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Icon(
                              Icons.arrow_downward_rounded,
                              color: Colors.grey[400],
                              size: 40,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Text(
                              'คุณ${widget.order['owner']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kTextPrimaryColor,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .fontSize),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(32),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    BuildHeadText(text: 'รายละเอียดผู้ชื้อ'),
                    BuildSubText(
                      leading: 'ชื่อ',
                      text: '${widget.order['owner']}',
                    ),
                    BuildSubText(
                      leading: 'ที่อยู่',
                      text: '${widget.order['receive_address']}',
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    BuildHeadText(text: 'รายละเอียดการสั่งซื้อ'),
                    BuildSubText(
                      leading: 'น้ำหนัก',
                      text: '${mapProduct['weight']}',
                    ),
                    BuildSubText(
                      leading: 'น้ำหนักที่สั่งซื้อ',
                      text: '${mapOrderItems['price_kg']}',
                    ),
                    BuildSubText(
                      leading: 'ค่าจัดส่ง',
                      text: '${widget.order['shipping']}',
                    ),
                    BuildSubText(
                      leading: 'รวมราคา',
                      text: '${mapOrderItems['price']}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: OutlineButton(
                highlightColor: kPrimaryLightColor,
                highlightedBorderColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                color: kPrimaryColor,
                onPressed: () {},
                child: Text(
                  'ยกเลิกคำสั่งซื้อ',
                  style: TextStyle(color: kPrimaryColor, fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  color: kPrimaryColor,
                  onPressed: () {},
                  child: Text(
                    'ยืนยันคำสั่งซื้อ',
                    style: TextStyle(color: kPrimaryLightColor, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildHeadText extends StatelessWidget {
  final String text;
  const BuildHeadText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.subtitle1.fontSize),
      ),
    );
  }
}

class BuildSubText extends StatelessWidget {
  final String leading;
  final String text;
  final double width;
  const BuildSubText({Key key, this.text, this.leading, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leading,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.subtitle2.fontSize),
          ),
          Container(
            width: width,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle2.fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
