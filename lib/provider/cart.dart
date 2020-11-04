import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/http_exception.dart';
import 'package:shop_app/provider/products.dart';
import 'package:http/http.dart' as http;

class CartItem {
  final String id;
  final String prodId;
  final String title;
  final String imgUrl;
  final int quantity;
  final double price;

  CartItem({
    @required this.prodId,
    @required this.id,
    @required this.title,
    this.imgUrl,
    @required this.quantity,
    @required this.price,
  });

  factory CartItem.fromJson(prodId, Map<String, dynamic> decodeData) {
    return CartItem(
        id: prodId,
        prodId: decodeData['productid'],
        title: decodeData['title'],
        price: decodeData['price'],
        imgUrl: decodeData['image'],
        quantity: decodeData['quantity']);
  }
}

class Cart with ChangeNotifier {
  final String authToken;
  final String userId;
  Cart(
    this.authToken,
    this.userId,
    this._cartItems,
  );
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  int get itemCount {
    return _cartItems == null ? 0 : _cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }

  Future<void> addItems({String productId, BuildContext context}) async {
    final requestUrl =
        'https://shop-app-67cbd.firebaseio.com/cartitem/$userId.json?auth=$authToken';
    final cartItem = _cartItems.values.toList();
    final index = cartItem.indexWhere((item) => item.prodId == productId);
//!_cartItems.containsKey(cartItem[index].id)
    if (index < 0) {
      final cartProduct =
          Provider.of<Products>(context, listen: false).findById(id: productId);
      try {
        final response = await http.post(requestUrl,
            body: json.encode({
              "productid": productId,
              "title": cartProduct.title,
              "price": cartProduct.price,
              "image": cartProduct.imageUrl,
              "quantity": 1
            }));
        // here productId set as cartItem key;
        _cartItems.putIfAbsent(json.decode(response.body)['name'], () {
          return CartItem(
            id: json.decode(response.body)['name'],
            prodId: productId,
            title: cartProduct.title,
            imgUrl: cartProduct.imageUrl,
            quantity: 1,
            price: cartProduct.price,
          );
        });
        notifyListeners();
      } on Exception catch (e) {
        print(e.toString());
      }
    } else {
      throw HttpException('already added to cart!');
    }
  }

  Future<void> fetchData() async {
    final requestUrl =
        'https://shop-app-67cbd.firebaseio.com/cartitem/$userId.json?auth=$authToken';

    try {
      final response = await http.get(requestUrl);
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return;
        }
        extractedData.forEach((cartItemUniqeNameAsKey, cartItemData) {
          _cartItems.putIfAbsent(cartItemUniqeNameAsKey,
              () => CartItem.fromJson(cartItemUniqeNameAsKey, cartItemData));
        });

        notifyListeners();
      }
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  void incrementAndDecremebtItemQuantity(
      String cartItemKey, bool increment) async {
    final url =
        'https://shop-app-67cbd.firebaseio.com/cartitem/$userId/$cartItemKey.json?auth=$authToken';
    final cartItem = _cartItems.values.toList();
    final index = cartItem.indexWhere((item) => item.id == cartItemKey);

    try {
      final response = await http.patch(url,
          body: json.encode({
            "quantity": increment == true
                ? cartItem[index].quantity + 1
                : cartItem[index].quantity != 1
                    ? cartItem[index].quantity - 1
                    : cartItem[index].quantity
          }));
      if (response.statusCode >= 400) {
        throw Exception();
      } else {
        if (_cartItems.containsKey(cartItemKey)) {
          _cartItems.update(
              cartItemKey,
              (existingItem) => CartItem(
                  id: existingItem.id,
                  prodId: existingItem.prodId,
                  title: existingItem.title,
                  quantity: increment == true
                      ? existingItem.quantity + 1
                      : existingItem.quantity != 1
                          ? existingItem.quantity - 1
                          : existingItem.quantity,

                  // that will increment each product count
                  price: existingItem.price,
                  imgUrl: existingItem.imgUrl));
          notifyListeners();
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> removerCartItem(String cartItemKey) async {
    final url =
        'https://shop-app-67cbd.firebaseio.com/cartitem/$userId/$cartItemKey.json?auth=$authToken';

    final cartItem = _cartItems.values.toList();
    final index = cartItem.indexWhere((item) => item.id == cartItemKey);
    _cartItems.remove(cartItemKey);
    final reservedData = cartItem[index];
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _cartItems.putIfAbsent(
          cartItemKey,
          () => CartItem(
              id: reservedData.id,
              prodId: reservedData.prodId,
              title: reservedData.title,
              price: reservedData.price,
              imgUrl: reservedData.imgUrl,
              quantity: reservedData.quantity));
      notifyListeners();
      throw HttpException('Couldn\'t deleted');
    }
  }

  Future<void> clearCart(List<CartItem> allCartItems) async {
    allCartItems.forEach((item) async {
      final url =
          'https://shop-app-67cbd.firebaseio.com/cartitem/$userId/${item.id}.json?auth=$authToken';
      final response = await http.delete(url);
      _cartItems.clear();
      notifyListeners();

      if (response.statusCode >= 400) {
        throw HttpException('Deletion not completed');
      }
    });
  }
}
