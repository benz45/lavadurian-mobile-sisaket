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
  Map<String, String> _gene = {
    '1': 'ทุเรียนภูเขาไฟ (หมอนทอง)',
    '2': 'ก้านยาว',
    '3': 'หมอนทอง',
    '4': 'ชะนี',
    '5': 'กระดุม',
    '6': 'หลงลับแล',
    '7': 'พวงมณี',
  };

  Map<String, String> _status = {
    '1': 'พร้อมขาย',
    '2': 'สั่งจองล่วงหน้า',
    '3': 'ยุติการขาย',
  };

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

  Map<String, String> get productGene => _gene;
  Map<String, String> get productStatus => _status;
}

class OrdertModel extends ChangeNotifier {
  Map<String, String> _orderStatus = {
    '1': 'รอรับออร์เดอร์',
    '2': 'รับออร์เดอร์',
    '3': 'รอการชำระเงิน',
    '4': 'แจ้งชำระเงินแล้ว',
    '5': 'ชำระเงินแล้ว',
    '6': 'จัดส่งสินค้าแล้ว',
    '7': 'ดำเนินการเสร็จสิ้น',
    '8': 'ยกเลิก',
  };

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

  Map<String, String> get orderStatus => _orderStatus;
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
