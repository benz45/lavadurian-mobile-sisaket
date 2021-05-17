import 'package:LavaDurian/Screens/ViewOrder/view_order_screen.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationCardOrder extends StatelessWidget {
  final int orderId;
  const OperationCardOrder({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final font = Theme.of(context).textTheme;

    OrdertModel _orderModel = Provider.of<OrdertModel>(context);
    ProductImageModel productImageModel = Provider.of<ProductImageModel>(context);

    final _order = _orderModel.getOrderFromId(orderId);
    final _orderItem = _orderModel.getOrderItemFromId(orderId);
    final int _lengthOrderItem = _orderModel.getLengthOrderItemById(orderId: orderId);

    List listProductImage = productImageModel.getProductImageFromProductId(productId: _orderItem[0]['product']);

    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
    var dateCreate = DateTime.parse(_order['date_created']).toLocal();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewOrderScreen(
              order: _order,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 0.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.04),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  /*
                  * Product hader image 
                  */
                  Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        width: 100,
                        height: 100,
                        child: listProductImage.length != 0
                            ? CachedNetworkImage(
                                filterQuality: FilterQuality.low,
                                fadeOutCurve: Curves.fastOutSlowIn,
                                cacheKey: listProductImage[0]['image'],
                                imageUrl: listProductImage[0]['image'],
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, _) => SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          backgroundColor: kPrimaryColor,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                errorWidget: (_, __, ___) => SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                      child: Icon(
                                    Icons.error_outline_rounded,
                                    color: Colors.grey[500],
                                  )),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(left: Radius.circular(18.0)),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/example.png',
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      if (_order['status'] == 1)
                        Container(
                          margin: EdgeInsets.all(6.8),
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: kErrorColor,
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              "ใหม่",
                              style: TextStyle(color: Colors.white, fontSize: 12.0),
                            ),
                          ),
                        ),
                      if (_order['status'] != 1)
                        Container(
                          margin: EdgeInsets.all(6.8),
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              "$_lengthOrderItem รายการ",
                              style: TextStyle(color: Colors.white, fontSize: 12.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 15),
                  /*
                  * Order detail
                  */
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            "${dateFormat.format(dateCreate)}",
                            style: TextStyle(
                              color: kTextSecondaryColor,
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            "${_order['owner']}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        FittedBox(
                          child: Text('น้ำหนัก ${_orderModel.orderStatus['${_order['status']}']}'),
                        ),
                        FittedBox(
                          child: Text(
                            'สถานะ ${_orderModel.orderStatus['${_order['status']}']}',
                            style: TextStyle(
                              color: _order['status'] == 1
                                  ? kAlertColor
                                  : _order['status'] == 3
                                      ? kTextSecondaryColor
                                      : _order['status'] == 8
                                          ? kTextSecondaryColor
                                          : kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Icon(Icons.arrow_forward_ios, color: kTextSecondaryColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
