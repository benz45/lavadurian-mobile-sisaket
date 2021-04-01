import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreModel extends ChangeNotifier {
  // Current id store
  int _idCurrentStore;

  Map<String, dynamic> _district = {
    '1': 'กันทรลักษณ์',
    '2': 'ขุนหาญ',
    '3': 'ศรีรัตนะ',
  };

  List<Map<String, dynamic>> _stores = [];

  List<Map<String, dynamic>> get getStores => _stores;

  Map<String, dynamic> get district => _district;

  get getCurrentIdStore {
    if (_idCurrentStore != null) {
      return _idCurrentStore;
    }
  }

  _filterCurrentStore() {
    if (_idCurrentStore != null) {
      List<Map> res = _stores.where((i) => i['id'] == _idCurrentStore).toList();
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
    if (res != null && res.length != 0) {
      return res[0]['status'];
    }
  }

  // Set current store and save id store to SharedPreferences.
  void setCurrentStore({@required value, user}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentStoreById = 'USERID_${user}_CURRENT_STORE';
    prefs.setInt(currentStoreById, value);
    _idCurrentStore = value;
    notifyListeners();
  }

  // on remove current store and change current store id.
  void onRemoveCurrentStore({@required id}) {
    List<Map> res = _stores.where((i) => i['id'] != id).toList();
    if (res != null && res.length != 0) {
      _idCurrentStore = res[0]['id'];
    } else
      _idCurrentStore = null;
    notifyListeners();
  }

  // Set store list.
  set setStores(List<Map<String, dynamic>> stores) {
    _stores = stores;
    notifyListeners();
  }

  // Add New Store
  set addStore(Map<String, dynamic> stores) {
    _stores.add(stores);
    _idCurrentStore = stores['id'];
    notifyListeners();
  }

  void clear() {
    _stores.clear();
    _idCurrentStore = null;
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

  // Filter product from id.
  getProductFromId({@required int id}) {
    final mapId = _products.where((e) => id == e['id']).toList();
    return mapId;
  }

  // Remove product.
  void removeProduct({@required productId}) {
    _products.removeWhere((element) => element['id'] == productId);
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
