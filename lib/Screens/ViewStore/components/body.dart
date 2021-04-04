import 'package:LavaDurian/Screens/BookBank/bookbank_add_screen.dart';
import 'package:LavaDurian/Screens/BookBank/bookbank_edit_screen.dart';
import 'package:LavaDurian/Screens/CreateProduct/create_product_screen.dart';
import 'package:LavaDurian/Screens/EditProduct/edit_product_screen.dart';
import 'package:LavaDurian/Screens/ViewStore/components/show_alert_dialog.dart';
import 'package:LavaDurian/Screens/ViewStore/edit_store_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final int storeID;
  const Body({Key key, this.storeID}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int storeID;
  StoreModel storeModel;
  ProductModel productModel;
  BookBankModel bookBankModel;
  Map<String, dynamic> store;
  Map<String, dynamic> bookbank;
  Map<String, String> productGene;
  Map<String, String> productStatus;
  Map<String, String> productGrade;

  List products = [];
  List bookbanks = [];

  @override
  void initState() {
    super.initState();
    storeModel = context.read<StoreModel>();
    productModel = context.read<ProductModel>();
    bookBankModel = context.read<BookBankModel>();
  }

  @override
  Widget build(BuildContext context) {
    if (storeModel.getStores.length != 0 && products.length == 0) {
      int index = storeModel.getStores
          .indexWhere((element) => element['id'] == widget.storeID);

      store = storeModel.getStores[index];
      for (var product in productModel.products) {
        if (product['store'] == widget.storeID) {
          products.add(product);
        }
      }

      productGene = productModel.productGene;
      productStatus = productModel.productStatus;
      productGrade = productModel.productGrade;
    }

    if (bookBankModel.bookbank.length != 0 && bookbanks.length == 0) {
      for (var bookbankItem in bookBankModel.bookbank) {
        if (bookbankItem['store'] == widget.storeID) {
          bookbanks.add(bookbankItem);
        }
      }
    }

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.album),
                      title: Text('${store['name']}'),
                      subtitle: Text('${store['slogan']}\n\n'
                          '${store['about']}\n\n'
                          'โทร ${store['phone1']} / ${store['phone2']}'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('แก้ไข',
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditStoreScreen(widget.storeID)));
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('ลบร้าน',
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          onPressed: () {
                            showAlertDialog(context, widget.storeID);
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "บัญชีของร้านค้า",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text(
                      'เพิ่มบัญชี',
                      style: TextStyle(fontSize: 16, color: kPrimaryColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BookBankAddScreen(storeID: widget.storeID)));
                    },
                  ),
                ],
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bookbanks.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookBankScreen(
                                  bookbankID: bookbanks[index]['id'])));
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.ac_unit),
                        title: Text(
                            "ชื่อบัญชี: ${bookbanks[index]['account_name']}\n"
                            "หมายเลข: ${bookbanks[index]['account_number']}\n"
                            "สาขา: ${bookbanks[index]['bank_branch']}\n"),
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "สินค้าภายในร้าน",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text(
                      'เพิ่มสิ้นค้า',
                      style: TextStyle(fontSize: 16, color: kPrimaryColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateProductScreen(
                            storeID: storeID,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProductScreen(
                                    productID: products[index]['id'])));
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/example.png'), // no matter how big it is, it won't overflow
                          ),
                          title: Text(
                              "${productGene[products[index]['gene'].toString()]}\n"
                              "เกรด : ${productGrade[products[index]['grade'].toString()]}\n"
                              "สถานะ : ${productStatus[products[index]['status'].toString()]}\n"
                              "จำนวน : ${products[index]['values']} ลูก\n"
                              "นำ้หนัก : ${products[index]['weight']} กก./ลูก\n"
                              "คำอธิบาย : ${products[index]['desc']}\n"),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
