import 'package:flutter/material.dart';
import 'package:flutter_app_1/screen/login.dart';
import '../data/database_helper.dart';
import '../widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({super.key});

  @override
  State<CategoryManagerScreen> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  int? _editingId;
  List<Map<String, dynamic>> _categories = [];
   Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadCategories();
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

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      if (_editingId == null) {
        await DatabaseHelper().insertCategory({
          'name': _nameController.text,
          'image': _imageController.text,
        });
      } else {
        await DatabaseHelper().updateCategory({
          'id': _editingId,
          'name': _nameController.text,
          'image': _imageController.text,
        });
      }
      _nameController.clear();
      _imageController.clear();
      _editingId = null;
      _loadCategories();
    }
  }

  Future<void> _deleteCategory(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa danh mục này?'),
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
      await DatabaseHelper().deleteCategory(id);
      _loadCategories();
    }
  }

  void _editCategory(Map<String, dynamic> category) {
    setState(() {
      _editingId = category['id'];
      _nameController.text = category['name'];
      _imageController.text = category['image'] ?? '';
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _imageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý danh mục'),
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
                            ? 'Thêm danh mục mới'
                            : 'Sửa danh mục',
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
                          labelText: 'Tên danh mục',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Nhập tên danh mục'
                                    : null,
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
                            onPressed: _saveCategory,
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
                  'Danh sách danh mục (${_categories.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _categories.isEmpty
                ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Chưa có danh mục nào',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
                : Column(
                  children:
                      _categories.map((cat) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[200],
                              child:
                                  cat['image'] != null && cat['image'] != ''
                                      ? ClipOval(
                                        child: Image.asset(
                                          'assets/images/${cat['image']}',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.category,
                                              size: 30,
                                            );
                                          },
                                        ),
                                      )
                                      : const Icon(Icons.category, size: 30),
                            ),
                            title: Text(
                              cat['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'ID: ${cat['id']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _editCategory(cat),
                                  tooltip: 'Sửa',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteCategory(cat['id']),
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
