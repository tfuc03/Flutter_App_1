import 'package:flutter_app_1/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'info.dart';
import 'contact_screen.dart';
import 'config_screen.dart';
import '../config/default.dart';
import 'register.dart';
import '../widgets/app_drawer.dart';
import '../getdata/weather_service.dart';
import '../getdata/news_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


const String ulrAssets = 'assets/images/';
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
      items:
          items.map((item) {
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
                          fontSize: 20,
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
  bool isDarkMode = false;
  int _selectedIndex = 0;
  late Map<String, dynamic>? _userInfo;
  
  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
    // Kiểm tra nếu có dữ liệu trong SharedPreferences
    _loadUserDataIfAvailable();
  }



  // Tải dữ liệu người dùng từ SharedPreferences nếu có
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
     // Hàm để lấy dữ liệu thời tiết
  Future<Map<String, dynamic>> _getWeatherData() async {
  WeatherService weatherService = WeatherService();
  final weatherData = await weatherService.fetchWeather('Hanoi');
  return weatherData;
}
   // Hàm để lấy dữ liệu tin tức
  Future<List<dynamic>> _getNewsData() async {
  NewsService newsService = NewsService();
  return await newsService.fetchTopHeadlines('us'); // Replace 'us' with the desired country code
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
                'Vui lòng đăng nhập để xem thông tin\n Hoặc đăng ký tài khoản',
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
                          builder:
                              (context) => Register(
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

  Widget _buildHomeScreen() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          CarouselWidget(),
          const SizedBox(height: 20),
          FutureBuilder<Map<String, dynamic>>(
            future: _getWeatherData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có dữ liệu thời tiết.'));
              } else {
                final weatherData = snapshot.data!;
                final temperatureCelsius = weatherData['main']['temp'];
                final weatherIcon = Icons.wb_sunny; // Replace with dynamic icon based on weather condition

                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(weatherIcon, color: Colors.white, size: 50),
                      title: Text(
                        'Thời tiết: ${weatherData['name']}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        'Nhiệt độ: ${temperatureCelsius.toStringAsFixed(1)}°C',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                );
              }
            },
          ),


          const SizedBox(height: 20),
          FutureBuilder<List<dynamic>>(
              future: _getNewsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else {
                  final newsData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: newsData.map((article) {
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            if (article['urlToImage'] != null)
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                child: Image.network(
                                  article['urlToImage'],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ListTile(
                              title: Text(
                                article['title'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                article['description'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  // Handle "Read more" action
                                },
                                child: Text("Read more"),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          // const SizedBox(height: 20),
          // CategoriesWidget(), // Replace with your actual categories widget or code
        ],
      ),
    ),
  );
}


// @override
// Widget build(BuildContext context) {
//   final List<Widget> _screens = [
//     SingleChildScrollView(
//       child: Column(
//         children: [
//           CarouselWidget(),
//           const SizedBox(height: 20),
//           FutureBuilder<Map<String, dynamic>>(
//             future: _getWeatherData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text('Lỗi: ${snapshot.error}');
//               } else {
//                 final weatherData = snapshot.data!;
//                 return Card(
//                   child: ListTile(
//                     title: Text('Thời tiết: ${weatherData['name']}'),
//                     subtitle: Text('Nhiệt độ: ${weatherData['main']['temp']}°C'),
//                   ),
//                 );
//               }
//             },
//           ),
//           const SizedBox(height: 20),
//           FutureBuilder<List<dynamic>>(
//             future: _getNewsData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text('Lỗi: ${snapshot.error}');
//               } else {
//                 final newsData = snapshot.data!;
//                 return Column(
//                   children: newsData.map((article) {
//                     return Card(
//                       child: ListTile(
//                         title: Text(article['title']),
//                         subtitle: Text(article['description'] ?? ''),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               }
//             },
//           ),

@override
Widget build(BuildContext context) {
  final List<Widget> _screens = [
    SingleChildScrollView(
      child: Column(
        children: [
          CarouselWidget(),
          const SizedBox(height: 20),
          FutureBuilder<Map<String, dynamic>>(
            future: _getWeatherData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else {
                final weatherData = snapshot.data!;
                final temperatureCelsius = weatherData['main']['temp'];
                final weatherIcon = Icons.wb_sunny; // Replace with dynamic icon based on weather condition

                // Determine colors based on theme
                final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.lightBlueAccent;
                final textColor = isDarkMode ? Colors.white : Colors.black;

                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [backgroundColor!, Colors.blueGrey]
                            : [Colors.lightBlueAccent, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(weatherIcon, color: textColor, size: 50),
                      title: Text(
                        'Thời tiết: ${weatherData['name']}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 18),
                      ),
                      subtitle: Text(
                        'Nhiệt độ: ${temperatureCelsius.toStringAsFixed(1)}°C',
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: textColor),
                        onPressed: _toggleTheme,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<dynamic>>(
            future: _getNewsData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Lỗi: ${snapshot.error}');
              } else {
                final newsData = snapshot.data!;
                return Column(
                  children: newsData.map((article) {
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          if (article['urlToImage'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.network(
                                article['urlToImage'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ListTile(
                            title: Text(
                              article['title'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              article['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // Handle "Read more" action
                              },
                              child: Text("Read more"),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
          // const SizedBox(height: 20),
          // CategoriesWidget(), // Replace with your actual categories widget or code
        ],
      ),
    ),
    ContactScreen(),
    _buildInfoScreen(),
    ConfigApp(),
  ];

  return Scaffold(
    appBar: AppBar(title: const Text('My App Flutter')),
    drawer: AppDrawer(
      context: context,
      userInfo: _userInfo,
      selectedIndex: _selectedIndex,
      onSelect: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      showSelected: true,
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
          icon: Icon(Icons.contact_phone),
          label: 'Contact',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Info'),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_fix_high),
          label: 'Config',
        ),
      ],
    ),
  );
}
}

