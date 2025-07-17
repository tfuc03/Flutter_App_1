import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/product.dart';
import '../getdata/product_data.dart';
import '../model/category.dart';
import '../getdata/category_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'contact_screen.dart';
import 'product_grid_screen.dart';
import 'product_table_screen.dart';
import 'info.dart';
import 'config_screen.dart';

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

  Future<void> _deleteAccount() async {
    bool confirmDelete = true; // Giả định xác nhận xóa
    if (confirmDelete) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      setState(() {
        _userInfo = null;
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh mục sản phẩm (List)')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    _userInfo != null
                        ? NetworkImage(_userInfo!['imageUrl'])
                        : const AssetImage('assets/images/avatar.jpg')
                            as ImageProvider,
              ),
              accountName: Text(
                _userInfo?['name'] ?? 'Chưa đăng nhập',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(_userInfo?['email'] ?? ''),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_phone),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Info'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            _userInfo != null
                                ? Info(
                                  name: _userInfo!['name'],
                                  imageUrl: _userInfo!['imageUrl'],
                                  email: _userInfo!['email'],
                                  phone: _userInfo!['phone'],
                                  gender: _userInfo!['gender'],
                                  likeMusic: _userInfo!['likeMusic'],
                                  likeMovie: _userInfo!['likeMovie'],
                                  likeBook: _userInfo!['likeBook'],
                                )
                                : const Login(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_fix_high),
              title: const Text('Config'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfigApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Sản phẩm (List)'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on),
              title: const Text('Sản phẩm (Grid)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductGridScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Sản phẩm (Table)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductTableScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            if (_userInfo != null)
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Hủy tài khoản',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteAccount();
                },
              ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Thoát'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('currentUser');
                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
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
