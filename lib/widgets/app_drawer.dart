import 'package:flutter/material.dart';
import '../screen/login.dart';
import '../screen/contact_screen.dart';
import '../screen/info.dart';
import '../screen/config_screen.dart';
import '../screen/product_list_screen.dart';
import '../screen/product_grid_screen.dart';
import '../screen/product_table_screen.dart';
import '../screen/category_manager_screen.dart';
import '../screen/product_manager_screen.dart';
import '../screen/firebase_category_manager_screen.dart';
import '../screen/firebase_product_manager_screen.dart';
import '../screen/firebase_product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  final Map<String, dynamic>? userInfo;
  final int? selectedIndex;
  final Function(int)? onSelect;
  final BuildContext context;
  final bool showSelected;

  const AppDrawer({
    super.key,
    required this.context,
    this.userInfo,
    this.selectedIndex,
    this.onSelect,
    this.showSelected = false,
  });

  Future<void> _deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (Route route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  userInfo != null
                      ? NetworkImage(userInfo!["imageUrl"])
                      : const AssetImage('assets/images/avatar.jpg')
                          as ImageProvider,
            ),
            accountName: Text(
              userInfo?['name'] ?? 'Chưa đăng nhập',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(userInfo?['email'] ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: showSelected && selectedIndex == 0,
            onTap: () {
              Navigator.pop(context);
              if (onSelect != null) {
                onSelect!(0);
              } else {
                Navigator.pushNamed(context, '/home');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text('Contact'),
            selected: showSelected && selectedIndex == 1,
            onTap: () {
              Navigator.pop(context);
              if (onSelect != null) {
                onSelect!(1);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactScreen(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Info'),
            selected: showSelected && selectedIndex == 2,
            onTap: () {
              Navigator.pop(context);
              if (onSelect != null) {
                onSelect!(2);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            userInfo != null
                                ? Info(
                                  name: userInfo!["name"],
                                  imageUrl: userInfo!["imageUrl"],
                                  email: userInfo!["email"],
                                  phone: userInfo!["phone"],
                                  gender: userInfo!["gender"],
                                  likeMusic: userInfo!["likeMusic"],
                                  likeMovie: userInfo!["likeMovie"],
                                  likeBook: userInfo!["likeBook"],
                                )
                                : const Login(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_fix_high),
            title: const Text('Config'),
            selected: showSelected && selectedIndex == 3,
            onTap: () {
              Navigator.pop(context);
              if (onSelect != null) {
                onSelect!(3);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfigApp()),
                );
              }
            },
          ),
          const Divider(),
          // SQLite Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.storage, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  'SQLite Database',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category, color: Colors.blue),
            title: const Text('Quản lý danh mục (SQLite)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryManagerScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory, color: Colors.blue),
            title: const Text('Quản lý sản phẩm (SQLite)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductManagerScreen(),
                ),
              );
            },
          ),
          const Divider(),
          // Firebase Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.cloud, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Firebase Firestore',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category, color: Colors.orange),
            title: const Text('Quản lý danh mục (Firebase)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirebaseCategoryManagerScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory, color: Colors.orange),
            title: const Text('Quản lý sản phẩm (Firebase)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirebaseProductManagerScreen(),
                ),
              );
            },
          ),
          const Divider(),
          // Product Display Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.view_list, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'Hiển thị sản phẩm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Colors.blue),
            title: const Text('Sản phẩm SQLite (List)'),
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
            leading: const Icon(Icons.list, color: Colors.orange),
            title: const Text('Sản phẩm Firebase (List)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirebaseProductListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.grid_on, color: Colors.blue),
            title: const Text('Sản phẩm SQLite (Grid)'),
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
            leading: const Icon(Icons.table_chart, color: Colors.blue),
            title: const Text('Sản phẩm SQLite (Table)'),
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
          if (userInfo != null)
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Hủy tài khoản',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _deleteAccount(context),
            ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Thoát'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('currentUser');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (Route route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
