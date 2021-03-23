import 'package:flutter/material.dart';

class StoreModel extends ChangeNotifier {
  // Current store
  int _currentStore;

  Map<String, dynamic> _district = {
    '1': 'กันทรลักษณ์',
    '2': 'ขุนหาญ',
    '3': 'ศรีรัตนะ',
  };

  List<Map<String, dynamic>> _stores = [];

  List<Map<String, dynamic>> get stores => _stores;
  Map<String, dynamic> get district => _district;

  get getCurrentIdStore {
    if (_currentStore != null) {
      return _currentStore;
    }
  }

  _filterCurrentStore() {
    if (_currentStore != null) {
      List<Map> res = _stores.where((i) => i['id'] == _currentStore).toList();
      return res.length != 0 ? res : [];
    }
  }

  List get getCurrentStore {
    List res = _filterCurrentStore();
    return res;
  }

  // Get status current store.
  get getCurrentStoreStatus {
    List res = _filterCurrentStore();
    return res.length != 0 ? res[0]['status'] : [];
  }

  set setCurrentStore(v) {
    _currentStore = v;
    notifyListeners();
  }

  set stores(List<Map<String, dynamic>> stores) {
    _stores = stores;
    notifyListeners();
  }

  void clear() {
    _stores.clear();
    _currentStore = null;
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

  Map<String, String> _grade = {
    '1': 'เกรดคุณภาพ',
    '2': 'เกรดพรีเมี่ยม',
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
  Map<String, String> get productGrade => _grade;
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
  List<Map<String, dynamic>> _orderItems = [];

  List<Map<String, dynamic>> get orders => _orders;
  List<Map<String, dynamic>> get orderItems => _orderItems;

  set orders(List<Map<String, dynamic>> orders) {
    _orders = orders;
    notifyListeners();
  }

  set orderItems(List<Map<String, dynamic>> orderItems) {
    _orderItems = orderItems;
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
