import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/category.dart';

class CategoryData {
  Future<List<Category>> getCategories() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/files/categorylist.json',
      );
      final data = await json.decode(response);
      return (data['data'] as List).map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }
}
