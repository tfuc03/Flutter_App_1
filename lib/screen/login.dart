import 'package:flutter/material.dart';
import 'package:flutter_app_1/screen/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _chkRemember = false;

  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: Padding(
  //       padding: EdgeInsets.all(8),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Image.network(
  //               height: 250,
  //               "https://icons.veryicon.com/png/o/miscellaneous/color-icon-library/user-286.png"
  //             ),
  //             Text(
  //               "LOGIN INFORMATION",
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 color: Colors.blueAccent,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             TextFormField(
  //               controller: null,
  //               decoration: InputDecoration(
  //                 hint: Text(
  //                   "User name",
  //                   style: TextStyle(fontStyle: FontStyle.italic),
  //                 ),
  //                 labelText: "User Name",
  //                 icon: Icon(Icons.account_circle),
  //               ),
  //             ),
  //             TextFormField(
  //               obscureText: true,
  //               controller: null,
  //               decoration: InputDecoration(
  //                 hint: Text(
  //                   "Password",
  //                   style: TextStyle(fontStyle: FontStyle.italic),
  //                 ),
  //                 labelText: "Password",
  //                 icon: Icon(Icons.key),
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     SizedBox(
  //                       width: 20,
  //                       height: 20,
  //                       child: Checkbox(
  //                         value: _chkRemember,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             _chkRemember = value!;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     const SizedBox(width: 15),
  //                     const Text(
  //                       'Remember me',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 TextButton(
  //                   onPressed: () {},
  //                   child: const Text("Forgot Password"),
  //                 ),
  //               ],
  //             ),
  //             ElevatedButton(
  //               child: Text("LOGIN"),
  //               onPressed: () {},
  //               style: ElevatedButton.styleFrom(
  //                 minimumSize: Size.fromHeight(60),
  //                 backgroundColor: Colors.blue,
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text("Don't have account?"),
  //                 TextButton(
  //                   onPressed: () {},
  //                   child: Text("Register"),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Login"),
    ),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                height: 250,
                "https://st.depositphotos.com/3538103/5151/i/950/depositphotos_51514147-stock-photo-business-man-icon.jpg"
              ),
              Text(
                "LOGIN INFORMATION",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: null,
                decoration: InputDecoration(
                  hint: Text(
                    "User name",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  labelText: "User Name",
                  icon: Icon(Icons.account_circle),
                ),
              ),
              TextFormField(
                obscureText: true,
                controller: null,
                decoration: InputDecoration(
                  hint: Text(
                    "Password",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  labelText: "Password",
                  icon: Icon(Icons.key),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _chkRemember,
                          onChanged: (value) {
                            setState(() {
                              _chkRemember = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password"),
                  ),
                ],
              ),
              ElevatedButton(
                child: Text("LOGIN"),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(60),
                  backgroundColor: Colors.blue,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
