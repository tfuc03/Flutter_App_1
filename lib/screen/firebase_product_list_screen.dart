import 'package:flutter/material.dart';
import '../data/firebase_helper.dart';
import '../widgets/app_drawer.dart';

class FirebaseProductListScreen extends StatefulWidget {
  const FirebaseProductListScreen({super.key});

  @override
  State<FirebaseProductListScreen> createState() =>
      _FirebaseProductListScreenState();
}

class _FirebaseProductListScreenState extends State<FirebaseProductListScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final productsData = await FirebaseHelper().getProducts();
      final categoriesData = await FirebaseHelper().getCategories();
      setState(() {
        _products = productsData;
        _categories = categoriesData;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  String _getCategoryName(String? categoryId) {
    if (categoryId == null) return 'Không có danh mục';
    final category = _categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': 'Không xác định'},
    );
    return category['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase - Sản phẩm (List)'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Làm mới',
          ),
        ],
      ),
      drawer: AppDrawer(
        context: context,
        userInfo: null,
        selectedIndex: null,
        showSelected: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: Row(
              children: [
                const Icon(Icons.cloud, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Sản phẩm từ Firebase (${_products.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _products.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Chưa có sản phẩm nào trên Firebase',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.orange[100],
                              ),
                              child:
                                  product['image'] != null &&
                                          product['image'] != ''
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/products/${product['image']}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.inventory,
                                              color: Colors.orange,
                                              size: 30,
                                            );
                                          },
                                        ),
                                      )
                                      : const Icon(
                                        Icons.inventory,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                            ),
                            title: Text(
                              product['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Giá: ${product['price']?.toString() ?? '0'} VNĐ',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Danh mục: ${_getCategoryName(product['categoryId'])}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                if (product['description'] != null &&
                                    product['description'] != '')
                                  Text(
                                    product['description'],
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cloud,
                                      size: 12,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Firebase',
                                      style: TextStyle(
                                        color: Colors.orange[600],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text(product['name'] ?? ''),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (product['image'] != null &&
                                              product['image'] != '')
                                            Container(
                                              width: double.infinity,
                                              height: 200,
                                              margin: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.grey[200],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  'assets/images/products/${product['image']}',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.inventory,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          Text(
                                            'Giá: ${product['price']?.toString() ?? '0'} VNĐ',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Danh mục: ${_getCategoryName(product['categoryId'])}',
                                          ),
                                          if (product['description'] != null &&
                                              product['description'] != '')
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: Text(
                                                'Mô tả: ${product['description']}',
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.cloud,
                                                size: 16,
                                                color: Colors.orange,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Dữ liệu từ Firebase',
                                                style: TextStyle(
                                                  color: Colors.orange[600],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('Đóng'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
