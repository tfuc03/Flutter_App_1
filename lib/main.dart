import 'package:flutter_app_1/screen/home.dart';
import 'package:flutter_app_1/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/welcome.dart';
import 'package:provider/provider.dart' as provider;
import 'state/counter_provider_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      ProviderScope(
      child: provider.ChangeNotifierProvider(
        create: (_) => CounterModel(),
        child: const MyApp(),
      ),
    ),
  );
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
        '/home': (context) => HomeScreen(),
        '/welcome': (context) => const Welcome(),
        '/login': (context) => const Login(),
      },
      home: Scaffold(body: Welcome()),
    );
  }
}

