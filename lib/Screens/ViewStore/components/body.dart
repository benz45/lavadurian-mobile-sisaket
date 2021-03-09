import 'package:LavaDurian/Screens/ViewProduct/product_edit_screen.dart';
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
  Map<String, dynamic> store;
  Map<String, String> productGene;
  Map<String, String> productStatus;
  Map<String, String> productGrade;

  List products = [];

  @override
  void initState() {
    super.initState();
    storeModel = context.read<StoreModel>();
    productModel = context.read<ProductModel>();
  }

  @override
  Widget build(BuildContext context) {
    if (storeModel.stores.length != 0) {
      int index = storeModel.stores
          .indexWhere((element) => element['id'] == widget.storeID);

      store = storeModel.stores[index];
      for (var product in productModel.products) {
        if (product['store'] == widget.storeID) {
          products.add(product);
        }
      }

      productGene = productModel.productGene;
      productStatus = productModel.productStatus;
      productGrade = productModel.productGrade;
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
                          child: const Text('แก้ไข'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('ลบร้าน'),
                          onPressed: () {/* ... */},
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
                                builder: (context) =>
                                    ProductEditScreen(products[index]['id'])));
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
                              "จำนวน : ${products[index]['gene']} ลูก\n"
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
