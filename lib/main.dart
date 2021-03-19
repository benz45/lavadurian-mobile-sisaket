import 'package:LavaDurian/app/splash_screen.dart';
import 'package:LavaDurian/models/bottomBar_model.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/signup_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingModel>(create: (_) => SettingModel()),
        ChangeNotifierProvider<UserModel>(create: (_) => UserModel()),
        ChangeNotifierProvider<StoreModel>(create: (_) => StoreModel()),
        ChangeNotifierProvider<ProductModel>(create: (_) => ProductModel()),
        ChangeNotifierProvider<OrdertModel>(create: (_) => OrdertModel()),
        ChangeNotifierProvider<ItemModel>(create: (_) => ItemModel()),
        ChangeNotifierProvider<SignupModel>(create: (_) => SignupModel()),
        ChangeNotifierProvider<BottomBarModel>(create: (_) => BottomBarModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lava Durian Sisaket',
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          }),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: GoogleFonts.kanit(fontWeight: FontWeight.w400).fontFamily,
        ),
        home: SplashPage(),
      ),
    );
  }
}
