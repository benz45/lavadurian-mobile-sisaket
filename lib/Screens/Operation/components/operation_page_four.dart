import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationPageFour extends StatelessWidget {
  const OperationPageFour({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreModel _storeModel = Provider.of<StoreModel>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .85,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Divider(),
            Center(
              child: Text('Store Coming soon...'),
            )
          ],
        ),
      ),
    );
  }
}
