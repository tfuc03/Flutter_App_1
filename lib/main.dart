import 'package:flutter/material.dart';
import 'package:flutter_app_1/screen/login.dart';
import 'package:flutter_app_1/screen/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
    WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My app Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/welcome': (context) => const Welcome(),
        '/login': (context) => const Login(),
      },
      home: Scaffold(body: Welcome()),
    );
  }
}

