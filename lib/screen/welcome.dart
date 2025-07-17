import 'package:flutter/material.dart';
import 'login.dart';
import '../config/default.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: clBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.network(
              "https://st2.depositphotos.com/3591429/6308/i/950/depositphotos_63081533-stock-photo-hands-holding-word-welcome.jpg ",
            ),
            const SizedBox(height: 32),
            Text(
              "Welcome to Flutter",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Họ tên: Phạm Nguyễn Trọng Phúc\nMSSV: 21DH111459",
              style: TextStyle(color: Colors.orange, fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: Text("Tiếp tục"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                fixedSize: const Size(100, 50),
              ),
            ),
            const SizedBox(height: 200), 
          ],
        ),
      ),
    );
  }
}