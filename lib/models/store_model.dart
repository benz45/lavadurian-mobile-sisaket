import 'package:flutter/material.dart';

class StoreModel extends ChangeNotifier {
  List<Map<String, dynamic>> _stores = [];

  List<Map<String, dynamic>> get stores => _stores;

  set stores(List<Map<String, dynamic>> stores) {
    _stores = stores;
    notifyListeners();
  }

  void clear() {
    _stores.clear();
    notifyListeners();
  }
}

class ProductModel extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products => _products;

  set products(List<Map<String, dynamic>> products) {
    _products = products;
    notifyListeners();
  }

  void clear() {
    _products.clear();
    notifyListeners();
  }
}

class OrdertModel extends ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => _orders;

  set orders(List<Map<String, dynamic>> orders) {
    _orders = orders;
    notifyListeners();
  }

  void clear() {
    _orders.clear();
    notifyListeners();
  }
}

class ItemModel extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  set items(List<Map<String, dynamic>> items) {
    _items = items;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
