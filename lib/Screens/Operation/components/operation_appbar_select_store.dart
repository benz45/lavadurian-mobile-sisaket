import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationAppBarSelectStore extends StatelessWidget {
  const OperationAppBarSelectStore({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreModel storeModel = Provider.of<StoreModel>(context);
    final currentIdStore = storeModel.getCurrentIdStore;

    return Expanded(
      child: ListView.builder(
        itemCount: storeModel.stores.length,
        shrinkWrap: true,
        itemBuilder: (context, item) {
          return RadioListTile(
            title: Text(
              '${storeModel.stores[item]['name']}'.replaceAll("", "\u{200B}"),
              overflow: TextOverflow.ellipsis,
            ),
            value: storeModel.stores[item]['id'],
            groupValue: currentIdStore,
            secondary: TextButton(
              child: Text(
                'ตั้งค่า',
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewStoreScreen(
                      storeModel.stores[item]['id'],
                    ),
                  ),
                );
              },
            ),
            onChanged: (value) {
              storeModel.setCurrentStore = value;
            },
            activeColor: kPrimaryColor,
          );
        },
      ),
    );
  }
}
