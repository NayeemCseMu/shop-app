import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/landing_page.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/route.dart';
import 'helper/page_transitions.dart';
import 'view/reusable-widget/splashscreen.dart';
import 'view/screens/auth_screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(null, null, []),
          update: (context, auth, previousData) => Products(auth.token,
              auth.userId, previousData == null ? [] : previousData.items),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (context) => Cart(null, null, {}),
          update: (context, auth, previousData) => Cart(auth.token, auth.userId,
              previousData == null ? [] : previousData.cartItems),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (context) => Order(null, null, []),
          update: (context, auth, previousData) => Order(auth.token,
              auth.userId, previousData == null ? [] : previousData.orderItem),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Shop_App',
          theme: ThemeData(
            // This is the theme of your application.
            primaryColor: Colors.indigo,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
                color: Colors.white,
                elevation: 0.5,
                textTheme: Theme.of(context).textTheme,
                centerTitle: true,
                iconTheme: IconTheme.of(context).copyWith(color: Colors.black)),
            accentColor: Colors.deepOrangeAccent,
            fontFamily: 'Lato',
            inputDecorationTheme: buildInputDecorationTheme(),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? LandingPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: routes,
        ),
      ),
    );
  }

  InputDecorationTheme buildInputDecorationTheme() {
    var outlineInputBorder = OutlineInputBorder(
        gapPadding: 6.0,
        borderSide: BorderSide(color: Colors.indigo, width: 1.0));
    return InputDecorationTheme(
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: Colors.green, width: 1.5)),
      border: outlineInputBorder,
    );
  }
}
