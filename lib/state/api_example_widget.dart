import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiExampleWidget extends StatefulWidget {
  const ApiExampleWidget({super.key});
  @override
  State<ApiExampleWidget> createState() => _ApiExampleWidgetState();
}

class _ApiExampleWidgetState extends State<ApiExampleWidget> {
  String? _title;
  bool _loading = false;

  Future<void> fetchData() async {
    setState(() {
      _loading = true;
    });
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _title = data['name'];
        _loading = false;
      });
    } else {
      setState(() {
        _title = 'Tfuc';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: fetchData, child: const Text('Gọi API')),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          )
        else if (_title != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Kết quả: $_title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
