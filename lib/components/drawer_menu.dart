import 'package:LavaDurian/Screens/Welcome/welcome_screen.dart';
import 'package:LavaDurian/app/operation.dart';
import 'package:LavaDurian/class/file_process.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = context.read<UserModel>();
  }

  @override
  Widget build(BuildContext context) {
    final storeUser = Provider.of<UserModel>(context);
    Future<void> _logout() async {
      FileProcess fileProcess = FileProcess('setting.json');
      try {
        storeUser.clear();
        fileProcess.writeData('{}');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      } catch (e) {
        print(e);
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
                "${userModel.value['first_name']} ${userModel.value['last_name']}"),
            accountEmail: Text("${userModel.value['email']}"),
            currentAccountPicture: CircleAvatar(
              child: FlutterLogo(
                size: 40.0,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('หน้าแรก'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OperationPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('ตั้งค่า'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text('ข้อมูลส่วนตัว'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('ออกจากระบบ'),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }
}
