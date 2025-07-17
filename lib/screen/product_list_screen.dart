import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/product.dart';
import '../getdata/product_data.dart';
import '../model/category.dart';
import '../getdata/category_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_drawer.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final CategoryData _categoryData = CategoryData();
  List<Category> _categories = [];
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadUserDataIfAvailable();
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryData.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _loadUserDataIfAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    final hasData = prefs.containsKey('name');

    if (hasData) {
      setState(() {
        _userInfo = {
          'name': prefs.getString('name') ?? 'User',
          'email': prefs.getString('email') ?? '',
          'phone': prefs.getString('phone') ?? '',
          'imageUrl': prefs.getString('imageUrl') ?? '',
          'gender': prefs.getInt('gender') ?? 0,
          'likeMusic': prefs.getBool('likeMusic') ?? false,
          'likeMovie': prefs.getBool('likeMovie') ?? false,
          'likeBook': prefs.getBool('likeBook') ?? false,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh mục sản phẩm (List)')),
      drawer: AppDrawer(
        context: context,
        userInfo: _userInfo,
        selectedIndex: null,
        showSelected: false,
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Image.asset('assets/images/${category.image}'),
              title: Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProductListByCategoryScreen(category: category),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductListByCategoryScreen extends StatefulWidget {
  final Category category;
  const ProductListByCategoryScreen({super.key, required this.category});

  @override
  State<ProductListByCategoryScreen> createState() =>
      _ProductListByCategoryScreenState();
}

class _ProductListByCategoryScreenState
    extends State<ProductListByCategoryScreen> {
  final ProductData _productData = ProductData();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _productData.getProducts();
    setState(() {
      _products =
          products.where((p) => p.categoryId == widget.category.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Image.asset(
                'assets/images/${product.image}',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                NumberFormat('###,###.###').format(product.price),
                style: const TextStyle(color: Colors.red),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
