import 'dart:convert';
import '../state/api_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
import '../state/counter_stateful_widget.dart';
import '../state/counter_provider_widget.dart';
import '../state/counter_getx_widget.dart';
import '../state/counter_riverpod_widget.dart';
import '../state/counter_bloc_widget.dart';
import '../state/counter_inherited_widget.dart';
import '../state/counter_mobx_widget.dart';
import '../state/counter_redux_widget.dart';
import '../state/api_example_widget.dart';
   import 'package:cached_network_image/cached_network_image.dart';

class AppDrawer extends StatefulWidget {
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

  
 @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int selectedDemoIndex = 0; // Initialize the selected index
  final List<String> demoTitles = [
    'Stateful',
    'Provider',
    'GetX',
    'Riverpod',
    'Bloc',
    'Inherited',
    'MobX',
    'Redux',
    'API Example',
    'API Data',
  ];

List<dynamic> apiData = [];


bool isLoading = false; 
  String? error;  

@override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

// Fetch data from an API
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });
  try {
    final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/list/all'));
    if (response.statusCode == 200) {
       final decoded = json.decode(response.body);
      final breedsMap = decoded['message'] as Map<String, dynamic>;
      final breedsList = breedsMap.keys.toList();
      setState(() {
        apiData = breedsList;
        isLoading = false;
      });
    } else {
      print('Failed to load data: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Thêm thông báo lỗi chi tiết
      throw Exception('Failed to load data: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    // Xử lý ngoại lệ
    print('An error occurred: $e');
    setState(() {
      isLoading = false;
      error = e.toString();
    });
  }
}

void showApiDataDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      if (isLoading) {
        return AlertDialog(
          title: const Text('API Data'),
          content: const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      }
      if (error != null) {
        return AlertDialog(
          title: const Text('API Data'),
          content: Text(error!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      }
      //  Dùng Container với width và height cố định
      return AlertDialog(
        title: const Text('API Data'),
        content: SizedBox(
          width: 400, // hoặc double.maxFinite
          height: 400,
          child: ApiDataWidget(apiData: apiData),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      );
    },
  );
}


Widget getDemoWidget(int index) {
    // Implement this function to return the appropriate widget
    switch (index) {
      case 0:
      return CounterStatefulWidget();
    case 1:
      return CounterProviderWidget();
    case 2:
      return CounterGetXWidget();
    case 3:
      return CounterRiverpodWidget(); // Assuming this is the widget in counter_riverpod_widget.dart
    case 4:
      return CounterBlocWidget(); // Assuming this is the widget in counter_bloc_widget.dart
    case 5:
      return CounterInheritedWidget(); // Assuming this is the widget in counter_inherited_widget.dart
    case 6:
      return CounterMobXWidget(); // Assuming this is the widget in counter_mobx_widget.dart
    case 7:
      return CounterReduxWidget(); // Assuming this is the widget in counter_redux_widget.dart
    case 8:
      return ApiExampleWidget(); // Assuming this is the widget in api_example_widget.dart
     case 9:
          if (isLoading) { 
          return const Center(child: CircularProgressIndicator()); 
        }
        if (error != null) {
          return Center(child: Text(error!)); 
        }
        return ApiDataWidget(apiData: apiData); 
    default:
      return Container(); // Default widget
    }
  }

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
              // backgroundImage:
              //     widget.userInfo != null
              //         ? NetworkImage(widget.userInfo!["imageUrl"])
              //         : const AssetImage('assets/images/avatar.jpg')
              //             as ImageProvider,
              child: widget.userInfo != null
           ? CachedNetworkImage(
               imageUrl: widget.userInfo!["imageUrl"],
               placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
             )
           : Image.asset('assets/images/avatar.jpg'),
            ),
            accountName: Text(
              widget.userInfo?['name'] ?? 'Chưa đăng nhập',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(widget.userInfo?['email'] ?? ''),
          ),
          // ListTile(
          //   leading: const Icon(Icons.home),
          //   title: const Text('Home'),
          //   selected: showSelected && selectedIndex == 0,
          //   onTap: () {
          //     Navigator.pop(context);
          //     if (onSelect != null) {
          //       onSelect!(0);
          //     } else {
          //       Navigator.pushNamed(context, '/home');
          //     }
          //   },
          // ),
           ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: widget.showSelected && widget.selectedIndex == 0,
            onTap: () {
              Navigator.pop(context);
             widget.onSelect?.call(0) ?? Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text('Contact'),
            selected: widget.showSelected && widget.selectedIndex == 1,
            onTap: () {
              Navigator.pop(context);
              if (widget.onSelect != null) {
                widget.onSelect!(1);
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
            selected: widget.showSelected && widget.selectedIndex == 2,
            onTap: () {
              Navigator.pop(context);
              if (widget.onSelect != null) {
                widget.onSelect!(2);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            widget.userInfo != null
                                ? Info(
                                  name: widget.userInfo!["name"],
                                  imageUrl: widget.userInfo!["imageUrl"],
                                  email: widget.userInfo!["email"],
                                  phone: widget.userInfo!["phone"],
                                  gender: widget.userInfo!["gender"],
                                  likeMusic: widget.userInfo!["likeMusic"],
                                  likeMovie: widget.userInfo!["likeMovie"],
                                  likeBook: widget.userInfo!["likeBook"],
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
            selected: widget.showSelected && widget.selectedIndex == 3,
            onTap: () {
              Navigator.pop(context);
              if (widget.onSelect != null) {
                widget.onSelect!(3);
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
           // ================= Demo State & API =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.developer_board,
                              color: Colors.blue,
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'State & API',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Chọn một phương pháp quản lý state hoặc demo API để xem ví dụ trực tiếp.',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            demoTitles.length,
                            (i) => ChoiceChip(
                              label: Text(demoTitles[i]),
                              selected: selectedDemoIndex == i,
                              selectedColor: Colors.blue.shade100,
                              labelStyle: TextStyle(
                                color:
                                    selectedDemoIndex == i
                                        ? Colors.blue.shade900
                                        : Colors.black87,
                                fontWeight:
                                    selectedDemoIndex == i
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                setState(() { 
                                 selectedDemoIndex = i; 
                                });
                                if (i == 9) { 
                                  showApiDataDialog(context);
                                } 
                              },
                            ),
                          ),
                        ),
                        const Divider(thickness: 2, height: 32),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            key: ValueKey(selectedDemoIndex),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: getDemoWidget(selectedDemoIndex),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.userInfo != null)
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
