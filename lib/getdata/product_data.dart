import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/product.dart';

class ProductData {
  Future<List<Product>> getProducts() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/files/productlist.json',
      );
      final data = await json.decode(response);
      return (data['data'] as List).map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      print('Error loading products: $e');
      return [];
    }
  }
}
