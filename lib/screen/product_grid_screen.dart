import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/product.dart';
import '../getdata/product_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_drawer.dart';

class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  final ProductData _productData = ProductData();
  List<Product> _products = [];
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadUserDataIfAvailable();
  }

  Future<void> _loadProducts() async {
    final products = await _productData.getProducts();
    setState(() {
      _products = products;
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
      appBar: AppBar(title: const Text('Danh sách sản phẩm')),
      drawer: AppDrawer(
        context: context,
        userInfo: _userInfo,
        selectedIndex: null,
        showSelected: false,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/${product.image}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NumberFormat('###,###.###').format(product.price),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
