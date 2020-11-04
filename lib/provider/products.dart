import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/http_exception.dart';
import 'products_model.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._item);
  List<ProductModel> _item = [];

  List<ProductModel> get items {
    return [..._item];
  }

  List<ProductModel> get favoriteItems {
    return _item.where((prodItem) => prodItem.isFavorite).toList();
  }

  ProductModel findById({@required String id}) {
    return _item.firstWhere((prod) => prod.id == id);
  }

  int selectedIndex = 0;
  void selectedNavItem(int index) {
    selectedIndex = index;

    notifyListeners();
  }

  int selectedTabIndex = 0;
  void selectedTabItem(int index) {
    selectedTabIndex = index;

    notifyListeners();
  }

  Future<void> addNewProduct(ProductModel productModel) async {
    final requestUrl =
        'https://shop-app-67cbd.firebaseio.com/products/${productModel.category}.json?auth=$authToken';
    try {
      final response = await http.post(
        requestUrl,
        body: json.encode({
          "title": productModel.title,
          "price": productModel.price,
          "description": productModel.description,
          "image": productModel.imageUrl,
          "creatorId": userId,
          "category": productModel.category
        }),
      );

      // print(response.statusCode);
      // print(json.decode(response.body));

      _item.add(ProductModel(
          id: json.decode(response.body)['name'],
          title: productModel.title,
          price: productModel.price,
          description: productModel.description,
          imageUrl: productModel.imageUrl,
          category: productModel.category));
      notifyListeners();
    } on Exception catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> fetchData(String cat, [bool filter = false]) async {
    final filterText = filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final requestUrl =
        'https://shop-app-67cbd.firebaseio.com/products/$cat.json?auth=$authToken&$filterText';
    try {
      final response = await http.get(requestUrl);
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        if (extractedData == null) {
          return;
        }
        final url =
            'https://shop-app-67cbd.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
        final favoriteResponse = await http.get(url);
        final favoriteData = json.decode(favoriteResponse.body);

        List<ProductModel> loadedData = [];
        extractedData.forEach((prodId, prodData) {
          loadedData.add(ProductModel.fromJson(prodId, prodData,
              favoriteData == null ? false : favoriteData[prodId] ?? false));
        });
        _item = loadedData;
        notifyListeners();
      }
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  Future<void> updateProduct(String id, ProductModel productModel) async {
    final index = _item.indexWhere((product) => product.id == id);
    if (index >= 0) {
      final requestUrl =
          'https://shop-app-67cbd.firebaseio.com/products/${productModel.category}/$id.json?auth=$authToken';
      await http.patch(
        requestUrl,
        body: json.encode({
          'title': productModel.title,
          'description': productModel.description,
          'price': productModel.price,
          'image': productModel.imageUrl,
        }),
      );
      _item[index] = productModel;
      notifyListeners();
    } else {
      print('not updated');
    }
  }

  Future<void> deleteProductItem(String id) async {
    final requestUrl =
        'https://shop-app-67cbd.firebaseio.com/products/$id.json?auth=$authToken';
    final index = _item.indexWhere((product) => product.id == id);
    var existingProduct = _item[index];
    _item.removeAt(index);
    final response = await http.delete(requestUrl);
    if (response.statusCode >= 401) {
      _item.insert(index, existingProduct);
      notifyListeners();

      throw HttpException('Could not delete!');
    }
    existingProduct = null;

    notifyListeners();
  }
}
