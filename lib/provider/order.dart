import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/http_exception.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double totalAmount;
  final DateTime dateTime;
  final List<CartItem> cartProducts;

  OrderItem({this.dateTime, this.cartProducts, this.id, this.totalAmount});

  factory OrderItem.fromJson(Map<String, dynamic> jsondata) {
    return OrderItem(
      id: jsondata['name'],
      totalAmount: jsondata['total'],
      cartProducts: jsondata['cartlist'],
      dateTime: jsondata['date'],
    );
  }
}

class Order with ChangeNotifier {
  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._orderItems);
  List<OrderItem> _orderItems = [];
  List<OrderItem> get orderItem {
    return [..._orderItems];
  }

  Future<void> placeToOrderList(
      {List<CartItem> cartProducts, double amount}) async {
    final url =
        'https://shop-app-67cbd.firebaseio.com/orders/$userId.json?auth=$authToken';

    final time = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': amount,
          'date': time.toIso8601String(),
          'products': cartProducts
              .map((item) => {
                    'id': item.id,
                    'productid': item.prodId,
                    'title': item.title,
                    'price': item.price,
                    'quantity': item.quantity,
                    'total': item.price * item.quantity,
                  })
              .toList(),
        }));
    if (response.statusCode >= 400) {
      throw HttpException('Order not placed successfully');
    }
    _orderItems.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          totalAmount: amount,
          cartProducts: cartProducts,
          dateTime: time,
        ));

    notifyListeners();
  }

  Future<void> fetchOrder() async {
    final url =
        'https://shop-app-67cbd.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      List<OrderItem> loadedData = [];
      extractedData.forEach((ordId, ordData) {
        loadedData.add(
          OrderItem(
            id: ordId,
            totalAmount: ordData['amount'],
            dateTime: DateTime.parse(ordData['date']),
            cartProducts: (ordData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    prodId: item['productid'],
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
          ),
        );
        _orderItems = loadedData;
      });

      notifyListeners();
    }
  }
}
