import 'package:flutter/material.dart';
import 'package:flutter_app_1/model/user.dart';
import 'detail.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _checkValue1 = false;
  bool _checkValue2 = false;
  bool _checkValue3 = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Register',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
              ),
            ),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Password',
            ),
          ),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Confirm Password',
            ),
          ),
          const SizedBox(height: 10),
          const Text('What is your gender?'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Male'),
                  leading: Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('Female'),
                  leading: Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('What is your favorite?'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      title: const Text('Music'),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _checkValue1,
                      onChanged: (value) {
                        setState(() {
                          _checkValue1 = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      title: const Text('Travel'),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _checkValue2,
                      onChanged: (value) {
                        setState(() {
                          _checkValue2 = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      title: const Text('Movie'),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _checkValue3,
                      onChanged: (value) {
                        setState(() {
                          _checkValue3 = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  var gender = '';
                  if (_gender == 'Male') {
                    gender = 'Male';
                  } else if (_gender == 'Female') {
                    gender = 'Female';
                  }
                  var favorite = '';
                  if (_checkValue1) {
                    favorite += 'Music, ';
                  }
                  if (_checkValue2) {
                    favorite += 'Travel, ';
                  }
                  if (_checkValue3) {
                    favorite += 'Movie, ';
                  }
                  if (favorite.isNotEmpty) {
                    favorite = favorite.substring(0, favorite.length - 2);
                  }
                  var user = User(
                    fullname: _nameController.text,
                    email: _emailController.text,
                    gender: gender,
                    favorite: favorite,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(user: user),
                    ),
                  );
                },
                child: const Text('Register'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}