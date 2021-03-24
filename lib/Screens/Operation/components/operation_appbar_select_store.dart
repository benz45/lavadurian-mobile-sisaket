import 'package:LavaDurian/Screens/ViewStore/view_store_screen.dart';
import 'package:LavaDurian/constants.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperationAppBarSelectStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer2<StoreModel, UserModel>(
        builder: (context, storeModel, userModel, child) {
          return ListView.builder(
            itemCount: storeModel.getStores.length,
            shrinkWrap: true,
            itemBuilder: (context, item) {
              return RadioListTile(
                title: Text(
                  '${storeModel.getStores[item]['name']}'
                      .replaceAll("", "\u{200B}"),
                  overflow: TextOverflow.ellipsis,
                ),
                value: storeModel.getStores[item]['id'],
                groupValue: storeModel.getCurrentIdStore,
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
                          storeModel.getStores[item]['id'],
                        ),
                      ),
                    );
                  },
                ),
                onChanged: (value) {
                  storeModel.setCurrentStore(
                      value: value, user: userModel.value['id']);
                },
                activeColor: kPrimaryColor,
              );
            },
          );
        },
      ),
    );
  }
}
