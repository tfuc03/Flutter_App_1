import 'package:flutter_app_1/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'info.dart';
import 'contact_screen.dart';
import 'config_screen.dart';
import '../config/default.dart';
import 'register.dart';

class CarouselWidget extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'image': '${ulrAssets}slider1.jpg',
      'title': 'Sinh Ra',
      'subtitle': 'Khởi đầu hành trình cuộc đời',
    },
    {
      'image': '${ulrAssets}slider2.jpg',
      'title': 'Thời Học Tiểu Học',
      'subtitle': 'Khám phá thế giới qua những trang sách',
    },
    {
      'image': '${ulrAssets}slider3.jpg',
      'title': 'Tốt Nghiệp Đại Học',
      'subtitle': 'Khép lại một chặng đường học tập',
    },
  ];

  CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 350.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: items.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      item['image']!,
                      height: 200,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item['title']!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['subtitle']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? userInfo;
  const HomeScreen({super.key, this.userInfo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
    _loadUserDataIfAvailable();
  }

  Future<void> _loadUserDataIfAvailable() async {
    if (_userInfo == null) {
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
  }

  Widget _buildInfoScreen() {
    if (_userInfo == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Vui lòng đăng nhập để xem thông tin\nHoặc đăng ký tài khoản',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: const Text("Đăng nhập"),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(
                            onRegisterComplete: (userInfo) {
                              setState(() {
                                _userInfo = userInfo;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text("Đăng ký"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Info(
      name: _userInfo!['name'],
      imageUrl: _userInfo!['imageUrl'],
      email: _userInfo!['email'],
      phone: _userInfo!['phone'],
      gender: _userInfo!['gender'],
      likeMusic: _userInfo!['likeMusic'],
      likeMovie: _userInfo!['likeMovie'],
      likeBook: _userInfo!['likeBook'],
    );
  }

  Future<void> _deleteAccount() async {
    bool confirmDelete = true; // Add confirmation logic if needed
    if (confirmDelete) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      setState(() {
        _userInfo = null;
      });
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (Route route) => false,
      );
    }
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          CarouselWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildHomeScreen(),
      ContactScreen(),
      _buildInfoScreen(),
      ConfigApp(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My App Flutter')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              accountName: Text(
                _userInfo?['name'] ?? 'Chưa đăng nhập',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(_userInfo?['email'] ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _userInfo != null
                    ? NetworkImage(_userInfo!['imageUrl'])
                    : const AssetImage('assets/images/avatar.jpg')
                        as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_phone),
              title: const Text('Contact'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Info'),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_fix_high),
              title: const Text('Config'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 3;
                });
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
                  (Route route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone), label: 'Contact'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Info'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_fix_high), label: 'Config'),
        ],
      ),
    );
  }
}