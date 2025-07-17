import 'package:flutter/material.dart';
import '../data/firebase_helper.dart';
import '../widgets/app_drawer.dart';

class FirebaseProductManagerScreen extends StatefulWidget {
  const FirebaseProductManagerScreen({super.key});

  @override
  State<FirebaseProductManagerScreen> createState() =>
      _FirebaseProductManagerScreenState();
}

class _FirebaseProductManagerScreenState
    extends State<FirebaseProductManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _editingId;
  String? _selectedCategoryId;
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

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final productData = {
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'image': _imageController.text,
          'description': _descriptionController.text,
          'categoryId': _selectedCategoryId,
        };

        if (_editingId == null) {
          await FirebaseHelper().insertProduct(productData);
        } else {
          await FirebaseHelper().updateProduct(_editingId!, productData);
        }

        _clearForm();
        _loadData();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Lưu thành công!')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  Future<void> _deleteProduct(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await FirebaseHelper().deleteProduct(id);
        _loadData();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Xóa thành công!')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  void _editProduct(Map<String, dynamic> product) {
    setState(() {
      _editingId = product['id'];
      _nameController.text = product['name'];
      _priceController.text = product['price'].toString();
      _imageController.text = product['image'] ?? '';
      _descriptionController.text = product['description'] ?? '';
      _selectedCategoryId = product['categoryId'];
    });
  }

  void _clearForm() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      _descriptionController.clear();
      _selectedCategoryId = null;
    });
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Firebase - Quản lý sản phẩm'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cloud, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            _editingId == null
                                ? 'Thêm sản phẩm mới (Firebase)'
                                : 'Sửa sản phẩm (Firebase)',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Tên sản phẩm',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.inventory),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Nhập tên sản phẩm'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Giá',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nhập giá sản phẩm';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Giá phải là số';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Danh mục',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items:
                            _categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category['id'],
                                child: Text(category['name']),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator:
                            (value) => value == null ? 'Chọn danh mục' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imageController,
                        decoration: const InputDecoration(
                          labelText: 'Tên file hình (vd: img_1.jpg)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Mô tả',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_editingId != null)
                            TextButton.icon(
                              onPressed: _clearForm,
                              icon: const Icon(Icons.cancel),
                              label: const Text('Hủy'),
                            ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _saveProduct,
                            icon: Icon(
                              _editingId == null ? Icons.add : Icons.save,
                            ),
                            label: Text(_editingId == null ? 'Thêm' : 'Lưu'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.cloud_queue, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Danh sách sản phẩm Firebase (${_products.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _products.isEmpty
                ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
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
                  ),
                )
                : Column(
                  children:
                      _products.map((product) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.orange[100],
                              child:
                                  product['image'] != null &&
                                          product['image'] != ''
                                      ? ClipOval(
                                        child: Image.asset(
                                          'assets/images/products/${product['image']}',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.inventory,
                                              size: 30,
                                              color: Colors.orange,
                                            );
                                          },
                                        ),
                                      )
                                      : const Icon(
                                        Icons.inventory,
                                        size: 30,
                                        color: Colors.orange,
                                      ),
                            ),
                            title: Text(
                              product['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Giá: ${product['price']?.toString() ?? '0'} VNĐ',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Danh mục: ${_getCategoryName(product['categoryId'])}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _editProduct(product),
                                  tooltip: 'Sửa',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _deleteProduct(product['id']),
                                  tooltip: 'Xóa',
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
