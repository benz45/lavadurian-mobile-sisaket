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

  get getCurrentIdStore => _idCurrentStore ?? null;

  Map _filterCurrentStore() {
    Map res = _stores.firstWhere((i) => i['id'] == _idCurrentStore, orElse: () => {});
    return res ?? {};
  }

  Map get getCurrentStore {
    Map res = _filterCurrentStore();
    return res;
  }

  // Get status current store.
  int get getCurrentStoreStatus {
    Map res = _filterCurrentStore();
    return res['status'] ?? 0;
  }

  // Set current store and save id store to SharedPreferences.
  void setCurrentStore({@required value, user}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentStoreById = 'USERID_${user}_CURRENT_STORE';

    // Set SharedPreferences current store
    await prefs.setInt(currentStoreById, value);

    // Set current store from id store (value = id store)
    _idCurrentStore = value;

    notifyListeners();
  }

  // on remove current store and change current store id.
  void onRemoveCurrentStore({@required id, @required int userId}) {
    List<Map> res = _stores.where((i) => i['id'] != id).toList();
    if (res != null && res.length != 0) {
      _idCurrentStore = res[0]['id'];
      setCurrentStore(value: _idCurrentStore, user: userId);
    } else
      _idCurrentStore = null;
    notifyListeners();
  }

  // Set store list.
  set setStores(List<Map<String, dynamic>> stores) {
    _stores = stores;
    notifyListeners();
  }

  // Update store list.
  void updateStores({@required int storeId, @required Map<String, dynamic> value}) {
    int index = _stores.indexWhere((element) => element['id'] == storeId);
    if (index != -1)
      value.forEach((key, value) {
        _stores[index].update(key, (_) => value);
      });
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

  // Fillter for product in current store
  getProductsFromStoreId(int idStore) {
    return _products.where((element) => element['store'] == idStore).toList();
  }

  // Filter product from id.
  getProductFromId({@required int id}) {
    final mapId = _products.where((e) => id == e['id']).toList();
    return mapId;
  }

  // Filter product from id.
  String getProductGeneFromId({@required int productId}) {
    final Map mapProducts = _products.firstWhere((e) => e['id'] == productId, orElse: () => null);
    if (mapProducts != null) {
      return "${_gene['${mapProducts['gene']}']}";
    }
    return "";
  }

  // Filter product from id.
  String getProductGradeFromId({@required int productId}) {
    final Map mapProducts = _products.firstWhere((e) => e['id'] == productId, orElse: () => null);
    if (mapProducts != null) {
      return "${_grade['${mapProducts['grade']}']}";
    }
    return "";
  }

  // Filter product from id.
  String getProductWeightFromId({@required int productId}) {
    final Map mapProducts = _products.firstWhere((e) => e['id'] == productId, orElse: () => null);
    if (mapProducts != null) {
      return "${mapProducts['weight']}";
    }
    return "";
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
  List<Map<String, dynamic>> _statusCount = [];

  List<Map<String, dynamic>> get orders => _orders;
  List<Map<String, dynamic>> get orderItems => _orderItems;
  List<Map<String, dynamic>> get statusCount => _statusCount;

  // Get order by Store ID
  getOrdersFromStoreId(int idStore) {
    return _orders.where((element) => element['store'] == idStore).toList();
  }

  // Get order by id
  getOrderFromId(int idOrder) {
    final order = _orders.firstWhere((element) => element['id'] == idOrder, orElse: () => {});
    return order;
  }

  // Get order item by id
  List getOrderItemFromId(int orderId) {
    final List order = _orderItems.where((element) => element['order'] == orderId).toList();
    return order;
  }

  // Filter order by id
  List filterOrderFromId({int orderId}) {
    final order = _orders.where((element) => element['order'] == orderId).toList();
    return order;
  }

  // Filter order by id
  List filterOrderItemOfProductFromId({int productId}) {
    final List _listorderItems = _orderItems.where((element) => element['product'] == productId).toList();

    return _listorderItems;
  }

  int getLengthOrderItemById({int orderId}) {
    final int _lengthOrderItems = _orderItems.where((element) => element['order'] == orderId).toList().length;
    return _lengthOrderItems;
  }

  set orders(List<Map<String, dynamic>> orders) {
    _orders = orders;
    notifyListeners();
  }

  set orderItems(List<Map<String, dynamic>> orderItems) {
    _orderItems = orderItems;
    notifyListeners();
  }

  // Update order
  void updateOrder({Map order, Map orderItem}) {
    int indexListOrder;
    int indexListOrderItem;

    if (order != null) {
      indexListOrder = _orders.indexWhere((element) => element['id'] == order['id']);
      order.forEach(
        (key, value) => _orders[indexListOrder].update(key, (_) => value),
      );
    }
    if (orderItem != null) {
      indexListOrderItem = _orderItems.indexWhere((element) => element['id'] == orderItem['id']);
      orderItem.forEach(
        (key, value) => _orderItems[indexListOrderItem].update(key, (_) => value),
      );
    }

    notifyListeners();
  }

  set statusCount(List<Map<String, dynamic>> statusCount) {
    _statusCount = statusCount;
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

class BookBankModel extends ChangeNotifier {
  List<Map<String, dynamic>> _bookbank = [];

  Map<String, String> _type = {
    '1': "กระแสรายวัน",
    '2': "ออมทรัพย์",
    '3': "เงินฝากประจำ",
  };

  Map<String, String> _bank = {
    "002": "ธนาคารกรุงเทพ",
    "004": "ธนาคารกสิกรไทย",
    "006": "ธนาคารกรุงไทย",
    "011": "ธนาคารทหารไทย",
    "014": "ธนาคารไทยพาณิชย์",
    "025": "ธนาคารกรุงศรีอยุธยา",
    "030": "ธนาคารออมสิน",
    "034": "ธนาคารเพื่อการเกษตรและสหกรณ์การเกษตร",
  };

  List getBookBankFromStoreId({@required int storeId}) {
    final List result = _bookbank.where((element) => element['store'] == storeId).toList();
    return result;
  }

  List<Map<String, dynamic>> get bookbank => _bookbank;
  Map<String, String> get type => _type;
  Map<String, String> get bank => _bank;

  set bookbank(List<Map<String, dynamic>> bookbank) {
    _bookbank = bookbank;
    notifyListeners();
  }

  set addBookbank(Map<String, dynamic> bookbank) {
    _bookbank.addAll([bookbank]);
    notifyListeners();
  }

  // Update bookbank
  void updateBookbank({@required int bookbankId, @required Map<String, dynamic> value}) {
    int index = _bookbank.indexWhere((element) => element['id'] == bookbankId);
    if (index != -1)
      value.forEach((key, value) {
        _bookbank[index].update(key, (_) => value);
      });
    notifyListeners();
  }

  void removeBookbank({@required int bookbankId}) {
    _bookbank.removeWhere((element) => element['id'] == bookbankId);
    notifyListeners();
  }

  void clear() {
    _bookbank.clear();
    notifyListeners();
  }
}

class QRCodeModel extends ChangeNotifier {
  List<Map<String, dynamic>> _qrcode = [];

  List<Map<String, dynamic>> get qrcode => _qrcode;

  // Set qrcode when get store profile.
  set setQRCode(List<Map<String, dynamic>> qrcode) {
    _qrcode = qrcode;
    notifyListeners();
  }

  // filter qr code by store id
  List getQRCodeFromStoreId(int storeId) {
    return _qrcode.where((element) => element['store'] == storeId).toList();
  }

  void addNewQRCode(Map<String, dynamic> data) {
    _qrcode.add(data);
    notifyListeners();
  }

  void removeQRCodeById(int id) {
    _qrcode.removeWhere((element) => element['id'] == id);
    notifyListeners();
  }

  void clear() {
    _qrcode.clear();
    notifyListeners();
  }
}
