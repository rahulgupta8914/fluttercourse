import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  String _authToken;
  String _userId;

  void update(String token, String userId, List<Product> lists) {
    _authToken = token;
    _items = lists;
    _userId = userId;
    // notifyListeners();
  }

  Future<void> fetchAndSetProdyucts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="authorId"&equalTo="$_userId"' : '';
    var url =
        'https://shop-app-45af2.firebaseio.com/products.json?auth=$_authToken$filterString';
    try {
      final List<Product> loadedProducts = [];
      final response = await http.get(url);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body != null) {
        var url =
            'https://shop-app-45af2.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken';
        final favoriteResponse = await http.get(url);
        var favoriteData = jsonDecode(favoriteResponse.body);
        favoriteData = favoriteData == null ? {} : favoriteData;
        body.forEach((key, value) {
          loadedProducts.add(Product(
              id: key,
              title: value['title'],
              description: value['description'],
              imageUrl: value['imageUrl'],
              isFavorite: favoriteData[key].runtimeType == bool
                  ? favoriteData[key]
                  : false,
              price: value['price']));
        });
        _items = loadedProducts;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-45af2.firebaseio.com/products.json?auth=$_authToken';
    final temp = {
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'authorId': _userId,
    };
    try {
      final response = await http.post(url, body: jsonEncode(temp));
      final tempProduct = Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(tempProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-45af2.firebaseio.com/products/$id.json?auth=$_authToken';
      await http.patch(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      notifyListeners();

      _items[prodIndex] = product;
    } else {
      // ...
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-45af2.firebaseio.com/products/$id.json?auth=$_authToken';
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
