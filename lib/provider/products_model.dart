import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../http_exception.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String creator;
  final String category;
  bool isFavorite;

  ProductModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.category,
    this.creator,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(
      prodId, Map<String, dynamic> decodeData, favoriteData) {
    return ProductModel(
        id: prodId,
        title: decodeData['title'],
        description: decodeData['description'],
        price: decodeData['price'],
        imageUrl: decodeData['image'],
        creator: decodeData['creatorId'],
        isFavorite: favoriteData,
        category: decodeData['category']);
  }

  Future<void> toogleFavorite(String authToken, String userId) async {
    final oldFavStatus = isFavorite;
    final url =
        'https://shop-app-67cbd.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';

    isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));

    if (response.statusCode >= 401) {
      isFavorite = oldFavStatus;
      notifyListeners();
      throw HttpException('Something went wrong!');
    }
  }
}
