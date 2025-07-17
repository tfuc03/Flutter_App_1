import 'package:flutter/material.dart';
import '../data/firebase_helper.dart';
import '../widgets/app_drawer.dart';

class FirebaseCategoryManagerScreen extends StatefulWidget {
  const FirebaseCategoryManagerScreen({super.key});

  @override
  State<FirebaseCategoryManagerScreen> createState() =>
      _FirebaseCategoryManagerScreenState();
}

class _FirebaseCategoryManagerScreenState
    extends State<FirebaseCategoryManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  String? _editingId;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await FirebaseHelper().getCategories();
      setState(() {
        _categories = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_editingId == null) {
          await FirebaseHelper().insertCategory({
            'name': _nameController.text,
            'image': _imageController.text,
          });
        } else {
          await FirebaseHelper().updateCategory(_editingId!, {
            'name': _nameController.text,
            'image': _imageController.text,
          });
        }
        _nameController.clear();
        _imageController.clear();
        _editingId = null;
        _loadCategories();
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

  Future<void> _deleteCategory(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text(
              'Bạn có chắc chắn muốn xóa danh mục này?\n\nTất cả sản phẩm trong danh mục này cũng sẽ bị xóa.',
            ),
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
        await FirebaseHelper().deleteCategory(id);
        _loadCategories();
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Firebase - Quản lý danh mục'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCategories,
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
                                ? 'Thêm danh mục mới (Firebase)'
                                : 'Sửa danh mục (Firebase)',
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
                  'Danh sách danh mục Firebase (${_categories.length})',
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
                        Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Chưa có danh mục nào trên Firebase',
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
                              backgroundColor: Colors.orange[100],
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
                                              color: Colors.orange,
                                            );
                                          },
                                        ),
                                      )
                                      : const Icon(
                                        Icons.category,
                                        size: 30,
                                        color: Colors.orange,
                                      ),
                            ),
                            title: Text(
                              cat['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID: ${cat['id']}',
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
