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
import 'product_list_screen.dart';
import 'info.dart';
import 'config_screen.dart';

class ProductTableScreen extends StatefulWidget {
  const ProductTableScreen({super.key});

  @override
  State<ProductTableScreen> createState() => _ProductTableScreenState();
}

class _ProductTableScreenState extends State<ProductTableScreen> {
  final ProductData _productData = ProductData();
  final CategoryData _categoryData = CategoryData();
  List<Product> _products = [];
  List<Category> _categories = [];
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUserDataIfAvailable();
  }

  Future<void> _loadData() async {
    final products = await _productData.getProducts();
    final categories = await _categoryData.getCategories();
    setState(() {
      _products = products;
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
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    }
  }

  String _getCategoryName(int id) {
    final cat = _categories.firstWhere(
      (c) => c.id == id,
      orElse: () => Category(id: 0, name: 'Không rõ', image: ''),
    );
    return cat.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bảng sản phẩm')),
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
                                : Login(),
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
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
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
              selected: true,
              onTap: () {
                Navigator.pop(context);
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
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text(
                'Hình ảnh',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Tên sản phẩm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Loại sản phẩm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text('Giá', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows:
              _products.map((product) {
                return DataRow(
                  cells: [
                    DataCell(Text(product.id.toString())),
                    DataCell(
                      Image.asset(
                        'assets/images/${product.image}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    DataCell(
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    DataCell(Text(_getCategoryName(product.categoryId))),
                    DataCell(
                      Text(
                        NumberFormat('###,###.###').format(product.price),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
