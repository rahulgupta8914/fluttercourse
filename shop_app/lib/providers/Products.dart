import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  Future<void> fetchAndSetProdyucts() async {
    const url = 'https://shop-app-45af2.firebaseio.com/products.json';
    try {
      final List<Product> loadedProducts = [];
      final response = await http.get(url);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body != null) {
        body.forEach((key, value) {
          loadedProducts.add(Product(
              id: key,
              title: value['title'],
              description: value['description'],
              imageUrl: value['imageUrl'],
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
    const url = 'https://shop-app-45af2.firebaseio.com/products.json';
    final temp = product.toMap();
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
      final url = 'https://shop-app-45af2.firebaseio.com/products/$id.json';
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
    final url = 'https://shop-app-45af2.firebaseio.com/products/$id.json';
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
