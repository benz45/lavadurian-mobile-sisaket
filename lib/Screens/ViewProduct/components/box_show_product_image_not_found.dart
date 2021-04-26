import 'package:LavaDurian/Screens/UploadImageProductScreen/upload_image_product_screen.dart';
import 'package:LavaDurian/actions/check_image_on_sever.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoxShowProductImageNotFound extends StatefulWidget {
  BoxShowProductImageNotFound({@required this.productId});
  int productId;

  @override
  _BoxShowProductImageNotFoundState createState() =>
      _BoxShowProductImageNotFoundState();
}

class _BoxShowProductImageNotFoundState
    extends State<BoxShowProductImageNotFound>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    productId = widget.productId;
  }

  int productId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProductImageModel productImageModel = Provider.of<ProductImageModel>(
      context,
    );

    List listProductImage =
        productImageModel.getProductImageFromProductId(productId: productId);

    return FutureBuilder(
      future: checkImageOnSever(imagelist: listProductImage),
      builder: (_, snap) {
        List resultCheckImageOnSever = snap?.data;
        return AnimatedSize(
          curve: Curves.easeOutQuart,
          duration: Duration(milliseconds: 300),
          vsync: this,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                switchInCurve: Curves.fastOutSlowIn,
                layoutBuilder:
                    (Widget currentChild, List<Widget> previousChildren) {
                  return Stack(
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                    alignment: Alignment.bottomCenter,
                  );
                },
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                duration: Duration(milliseconds: 300),
                child: snap.hasData &&
                        resultCheckImageOnSever.length !=
                            listProductImage.length
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: kErrorColor.withOpacity(.75),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * .6,
                                child: Text(
                                  'มีรูปภาพจำนวน ${listProductImage.length - snap.data.length} รูป ไม่สามารถแสดงผลได้หรือถูกลบออก',
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductImageUpload(
                                        productId: productId,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Text(
                                    'จัดการ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}
