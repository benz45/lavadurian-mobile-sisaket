import 'package:flutter/material.dart';

class ProductImageModel extends ChangeNotifier {
  List<Map<String, dynamic>> _images = [];

  List<Map<String, dynamic>> get images => _images;

  List getProductImageFromProductId({@required int productId}) {
    List result =
        _images.where((element) => element['product'] == productId).toList();
    return result ?? [];
  }

  void removeProductImageFromImageId({@required int imageId}) {
    _images.removeWhere((element) => element['id'] == imageId);
    notifyListeners();
  }

  set images(List<Map<String, dynamic>> images) {
    _images = images;
    notifyListeners();
  }

  void addImage({@required List listImage}) {
    listImage.forEach((element) {
      _images.add(element);
    });
    notifyListeners();
  }

  void clear() {
    _images.clear();
    notifyListeners();
  }
}
