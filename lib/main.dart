import 'package:LavaDurian/Screens/ViewOrder/view_order_screen.dart';
import 'package:LavaDurian/app/splash_screen.dart';
import 'package:LavaDurian/models/bottomBar_model.dart';
import 'package:LavaDurian/models/createProduct_model.dart';
import 'package:LavaDurian/models/createStore_model.dart';
import 'package:LavaDurian/models/productImage_model.dart';
import 'package:LavaDurian/models/profile_model.dart';
import 'package:LavaDurian/models/setting_model.dart';
import 'package:LavaDurian/models/signup_model.dart';
import 'package:LavaDurian/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/**
 * * Run main app
 * * by prevent device orientation
 */
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new LavaDurianApp());
  });
}

class LavaDurianApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingModel>(create: (_) => SettingModel()),
        ChangeNotifierProvider<StoreModel>(create: (_) => StoreModel()),
        ChangeNotifierProvider<UserModel>(create: (_) => UserModel()),
        ChangeNotifierProvider<OrdertModel>(create: (_) => OrdertModel()),
        ChangeNotifierProvider<ProductModel>(create: (_) => ProductModel()),
        ChangeNotifierProvider<BookBankModel>(create: (_) => BookBankModel()),
        ChangeNotifierProvider<QRCodeModel>(create: (_) => QRCodeModel()),
        ChangeNotifierProvider<SizeViewOrderModel>(create: (_) => SizeViewOrderModel()),
        ChangeNotifierProvider<ProductImageModel>(create: (_) => ProductImageModel()),
        ChangeNotifierProvider<SignupModel>(create: (_) => SignupModel()),
        ChangeNotifierProvider<CreateProductModel>(create: (_) => CreateProductModel()),
        ChangeNotifierProvider<CreateStoreModel>(create: (_) => CreateStoreModel()),
        ChangeNotifierProvider<BottomBarModel>(create: (_) => BottomBarModel()),
      ],
      child: RefreshConfiguration(
        headerBuilder: () => ClassicHeader(),
        footerBuilder: () => ClassicFooter(),
        headerTriggerDistance: 80.0,
        springDescription: SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        maxOverScrollExtent: 100,
        maxUnderScrollExtent: 0,
        enableScrollWhenRefreshCompleted: true,
        enableLoadingWhenFailed: true,
        hideFooterWhenNotFull: false,
        enableBallisticLoad: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lava Durian Sisaket',
          theme: ThemeData(
            textTheme: TextTheme(
              headline6: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
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
      ),
    );
  }
}
