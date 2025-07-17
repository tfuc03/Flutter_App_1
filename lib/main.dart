import 'package:flutter/material.dart';
     import 'mainpage.dart';
// import 'screen/welcome.dart';
// import 'package:flutter/mainpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Mainpage(
        // appBar: AppBar(title: Text("Tuan_01")),
        // body: Welcome(),
      ),
    );
  }
}
