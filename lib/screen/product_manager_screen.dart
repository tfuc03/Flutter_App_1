import 'package:flutter/material.dart';
import 'package:flutter_app_1/screen/login.dart';
import '../data/database_helper.dart';
import '../widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductManagerScreen extends StatefulWidget {
  const ProductManagerScreen({super.key});

  @override
  State<ProductManagerScreen> createState() => _ProductManagerScreenState();
}

class _ProductManagerScreenState extends State<ProductManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descController = TextEditingController();
  int? _editingId;
  int? _selectedCategoryId;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
   Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
    _loadUserDataIfAvailable();
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
  } else {
    // Xử lý trường hợp không có dữ liệu người dùng
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}

  Future<void> _loadCategories() async {
    final data = await DatabaseHelper().getCategories();
    setState(() {
      _categories = data;
    });
  }

  Future<void> _loadProducts() async {
    final data = await DatabaseHelper().getProducts();
    setState(() {
      _products = data;
    });
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      if (_editingId == null) {
        await DatabaseHelper().insertProduct({
          'name': _nameController.text,
          'price': double.tryParse(_priceController.text) ?? 0,
          'image': _imageController.text,
          'description': _descController.text,
          'categoryId': _selectedCategoryId,
        });
      } else {
        await DatabaseHelper().updateProduct({
          'id': _editingId,
          'name': _nameController.text,
          'price': double.tryParse(_priceController.text) ?? 0,
          'image': _imageController.text,
          'description': _descController.text,
          'categoryId': _selectedCategoryId,
        });
      }
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      _descController.clear();
      _editingId = null;
      _selectedCategoryId = null;
      _loadProducts();
    }
  }

  Future<void> _deleteProduct(int id) async {
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
      await DatabaseHelper().deleteProduct(id);
      _loadProducts();
    }
  }

  void _editProduct(Map<String, dynamic> product) {
    setState(() {
      _editingId = product['id'];
      _nameController.text = product['name'];
      _priceController.text = product['price'].toString();
      _imageController.text = product['image'] ?? '';
      _descController.text = product['description'] ?? '';
      _selectedCategoryId = product['categoryId'];
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      _descController.clear();
      _selectedCategoryId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(
        context: context,
        userInfo: _userInfo,
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
                      Text(
                        _editingId == null
                            ? 'Thêm sản phẩm mới'
                            : 'Sửa sản phẩm',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        enableSuggestions: false,
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
                        decoration: const InputDecoration(
                          labelText: 'Giá',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Nhập giá'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _selectedCategoryId,
                        items:
                            _categories.map((cat) {
                              return DropdownMenuItem<int>(
                                value: cat['id'],
                                child: Text(cat['name']),
                              );
                            }).toList(),
                        onChanged:
                            (val) => setState(() => _selectedCategoryId = val),
                        decoration: const InputDecoration(
                          labelText: 'Chọn loại',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        validator:
                            (value) =>
                                value == null ? 'Chọn loại sản phẩm' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imageController,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: 'Tên file hình (vd: iphone.png)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descController,
                        textCapitalization: TextCapitalization.none,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: 'Mô tả',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_editingId != null)
                            TextButton.icon(
                              onPressed: _cancelEdit,
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
                              backgroundColor: Colors.blue,
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
                const Icon(Icons.list, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Danh sách sản phẩm (${_products.length})',
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
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Chưa có sản phẩm nào',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
                : Column(
                  children:
                      _products.map((p) {
                        final cat = _categories.firstWhere(
                          (c) => c['id'] == p['categoryId'],
                          orElse: () => {'name': 'Không rõ'},
                        );
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[200],
                              child:
                                  p['image'] != null && p['image'] != ''
                                      ? ClipOval(
                                        child: Image.asset(
                                          'assets/images/products/${p['image']}',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.image,
                                              size: 30,
                                            );
                                          },
                                        ),
                                      )
                                      : const Icon(Icons.image, size: 30),
                            ),
                            title: Text(
                              p['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Giá: ${p['price'].toStringAsFixed(0)} VNĐ',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Loại: ${cat['name']}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                if (p['description'] != null &&
                                    p['description'] != '')
                                  Text(
                                    'Mô tả: ${p['description']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                  onPressed: () => _editProduct(p),
                                  tooltip: 'Sửa',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteProduct(p['id']),
                                  tooltip: 'Xóa',
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
            const SizedBox(
              height: 100,
            ), // Thêm khoảng trống cuối để tránh bị che bởi bàn phím
          ],
        ),
      ),
    );
  }
}
