import 'package:LavaDurian/Screens/EditProduct/edit_product_screen.dart';
import 'package:LavaDurian/Screens/UploadImageProductScreen/upload_image_product_screen.dart';
import 'package:LavaDurian/Screens/ViewProduct/components/dialog_can_not_action_product.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:LavaDurian/constants.dart';
import 'package:provider/provider.dart';
import 'components/dialog_delete_product.dart';

class ViewProductScreen extends StatefulWidget {
  final String hero;
  final String gene;
  final String status;
  final int productId;

  ViewProductScreen(
      {Key key, this.hero, this.status, this.gene, @required int productId})
      : this.productId = productId,
        super(key: key);

  @override
  _ViewProductScreenState createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  AnimationController animateController;

  OrdertModel ordertModel;
  @override
  void initState() {
    super.initState();
    ordertModel = context.read<OrdertModel>();
  }

  Future<void> _showOnDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Consumer<OrdertModel>(builder: (_, ordertModel, c) {
          // Filter order id
          final order = ordertModel.orderItems
              .where((e) => e['product'] == widget.productId);

          if (order.isEmpty) {
            return DialogDeleteProduct(
              productId: widget.productId,
            );
          } else {
            return DialoCanNotgActionProduct(
              orderId: order.first['id'],
              title: 'ไม่สามารถลบสินค้าได้',
            );
          }
        });
      },
    );
  }

  void _onNavigatorEditProductScreen() {
    if (widget.productId != null) {
      final order = ordertModel.orderItems
          .firstWhere((e) => e['product'] == widget.productId);

      if (order.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProductScreen(
              productID: widget.productId,
            ),
          ),
        );
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return DialoCanNotgActionProduct(
              orderId: order['id'],
              title: 'ไม่สามารถแก้ไขสินค้าได้',
            );
          },
        );
      }
    }
  }

  void _onNavigatorUploadImageProductScreen() {
    if (widget.productId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductImageUpload(
            productId: widget.productId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextTheme font = Theme.of(context).textTheme;
    ProductModel productModel =
        Provider.of<ProductModel>(context, listen: false);

    //* Product id
    final int id = widget.productId;

    //* Filter product from product id.
    final Map dataProduct = productModel.getProductFromId(id: id)[0];

    //* Filter product gene.
    final String productGene =
        productModel.productGene['${dataProduct['gene']}'];

    //* Filter product grade.
    final String productGrade =
        productModel.productGrade['${dataProduct['grade']}'];

    //* Filter product status.
    final String productStatus =
        productModel.productStatus['${dataProduct['status']}'];
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
                      // ! Icons header
                      Row(
                        children: [
                          // * Icons Upload Image Product
                          ClipOval(
                            child: Material(
                              color: Colors.white.withOpacity(0.2),
                              child: InkWell(
                                child: IconButton(
                                  onPressed:
                                      _onNavigatorUploadImageProductScreen,
                                  icon: Icon(Icons.add_photo_alternate),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          // * Icons Edit Product
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
                          // * Icons Delete Product
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
              expandedHeight: size.height,
              flexibleSpace: FlexibleSpaceBar(
                background: SingleChildScrollView(
                  child: Container(
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
                          padding:
                              EdgeInsets.only(left: 28, top: 26, right: 28),
                          width: size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // ! Header title
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "$productGene".replaceAll("", "\u{200B}"),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: font.headline6.fontSize),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  if (dataProduct['grade'] == 2)
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.amber[600],
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "$productGrade",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                                fontSize:
                                                    font.subtitle2.fontSize),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              // ! Store name
                              Consumer<StoreModel>(builder: (_, storeModel, c) {
                                final Map dataStore =
                                    storeModel.getCurrentStore[0];
                                if (dataStore != null) {
                                  return Text(
                                    "${dataStore['name']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kTextSecondaryColor,
                                        fontSize: font.subtitle2.fontSize),
                                  );
                                }
                                return Container();
                              }),
                              SizedBox(
                                height: 18,
                              ),
                              Divider(),

                              // ! Grade and Status
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "คุณภาพ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  font.subtitle1.fontSize),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "$productGrade",
                                          style: TextStyle(
                                              color: kTextSecondaryColor,
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  font.subtitle2.fontSize),
                                        ),
                                      ],
                                    ),
                                    VerticalDivider(),
                                    Column(
                                      children: [
                                        Text(
                                          "สถานะ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  font.subtitle1.fontSize),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "$productStatus",
                                              style: TextStyle(
                                                  color: kTextSecondaryColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize:
                                                      font.subtitle2.fontSize),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            if (dataProduct['status'] == 1)
                                              Icon(
                                                Icons
                                                    .check_circle_outline_outlined,
                                                color: Colors.green[500],
                                                size: font.subtitle1.fontSize,
                                              ),
                                            if (dataProduct['status'] == 2)
                                              Icon(
                                                Icons.access_time_outlined,
                                                color: kTextSecondaryColor,
                                                size: font.subtitle1.fontSize,
                                              ),
                                            if (dataProduct['status'] == 3)
                                              Icon(
                                                Icons
                                                    .remove_circle_outline_sharp,
                                                color: kErrorColor,
                                                size: font.subtitle1.fontSize,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Divider(),

                              // ! Description
                              Text(
                                "รายละเอียด",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: font.subtitle1.fontSize),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "${dataProduct['desc']}",
                                style: TextStyle(
                                    color: kTextSecondaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: font.subtitle2.fontSize),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Divider(),

                              // ! Description product
                              Text(
                                "รายละเอียดสินค้า",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: font.subtitle1.fontSize),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'จำนวน',
                                    style:
                                        TextStyle(color: kTextSecondaryColor),
                                  ),
                                  Text(
                                    '${dataProduct['values']}',
                                    style:
                                        TextStyle(color: kTextSecondaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'น้ำหนัก/ลูก',
                                    style:
                                        TextStyle(color: kTextSecondaryColor),
                                  ),
                                  Text(
                                    '${dataProduct['weight']} กก.',
                                    style:
                                        TextStyle(color: kTextSecondaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ราคา',
                                    style:
                                        TextStyle(color: kTextSecondaryColor),
                                  ),
                                  Text(
                                    '${dataProduct['price']} บาท/ลูก',
                                    style: TextStyle(
                                        color: kTextPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: font.subtitle1.fontSize),
                                  ),
                                ],
                              ),
                              // ! Space bottom
                              SizedBox(
                                height: 70,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
