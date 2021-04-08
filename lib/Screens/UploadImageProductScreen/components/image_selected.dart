import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class ImageSelected extends StatefulWidget {
  final int productID;
  const ImageSelected({Key key, this.productID}) : super(key: key);
  @override
  _ImageSelectedState createState() => _ImageSelectedState();
}

class _ImageSelectedState extends State<ImageSelected> {
  ProductImageModel productImageModel;
  List imageList;

  List consumeImage(int productID) {
    List list = [];
    for (var image in productImageModel.images) {
      if (image['product'] == productID) {
        list.add(image['image']);
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    productImageModel = context.read<ProductImageModel>();
  }

  @override
  Widget build(BuildContext context) {
    imageList = consumeImage(widget.productID);
    Size size = MediaQuery.of(context).size;

    return imageList.length != 0
        ? GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(12),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
            children: [
              for (var index = 0; index < imageList.length; index++)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    // * Container image.
                    Container(
                      width: (size.height * 0.2).round() + .0,
                      height: (size.height * 0.2).round() + .0,
                      child: Card(
                        margin: EdgeInsets.all(0),
                        semanticContainer: true,
                        elevation: 0.2,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        child:
                            Image.network(imageList[index], fit: BoxFit.fill),
                      ),
                    ),
                    // * Cancel select image.
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        height: 28,
                        width: 28,
                        child: Center(
                          child: ClipOval(
                            child: Material(
                              color: Colors.white.withOpacity(0.75),
                              child: IconButton(
                                onPressed: () {
                                  // ! To Do Remove Action.
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 13,
                                ),
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          )
        : Container();
  }
}
