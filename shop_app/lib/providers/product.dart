import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavorite = false});

  Future<void> toggleFavorite(String token, userId) async {
    final url =
        'https://shop-app-45af2.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: jsonEncode(isFavorite));
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': this.id,
      'title': this.title,
      'description': this.description,
      'imageUrl': this.imageUrl,
      'price': this.price,
      // 'isFavorite': this.isFavorite
    };
  }
}
