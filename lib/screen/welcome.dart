import 'package:flutter/material.dart';
import 'login.dart';
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 64),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.network(
              height: 150,
              "https://st2.depositphotos.com/3591429/6308/i/950/depositphotos_63081533-stock-photo-hands-holding-word-welcome.jpg                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ",
            ),
            SizedBox(height: 32),
            Text(
              "Welcome to Flutter",
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "My name is Tfuc\nStudent Code: 21DH111459",
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                fixedSize: Size(150, 70),
              ),
              onPressed: () {
                 Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),);
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
