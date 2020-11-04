import 'package:flutter/material.dart';
import 'package:shop_app/landing_page.dart';
import 'view/screens/add_new_product/new_data_screen.dart';
import 'view/screens/auth_screens/auth_screen.dart';
import 'view/screens/manage_product/manage_products_screen.dart';
import 'view/screens/cart/cart_screen.dart';
import 'view/screens/product/product_screen.dart';
import 'view/screens/order/order_screen.dart';
import 'view/screens/product_details/product_details_screen.dart';

final Map<String, WidgetBuilder> routes = {
  ProductScreen.routeName: (context) => ProductScreen(),
  ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
  CartOverViewScreen.routeName: (context) => CartOverViewScreen(),
  OrderOverViewScreen.routeName: (context) => OrderOverViewScreen(),
  ManageProduct.routeName: (context) => ManageProduct(),
  NewProduct.routeName: (context) => NewProduct(),
  LandingPage.routeName: (context) => LandingPage(),
  AuthScreen.routeName: (context) => AuthScreen(),
};
