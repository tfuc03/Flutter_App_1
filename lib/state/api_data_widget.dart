import 'package:flutter/material.dart';

class ApiDataWidget extends StatelessWidget {
  final List<dynamic> apiData;

  const ApiDataWidget({required this.apiData, Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {
    if (apiData.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }
    return SizedBox(
      height: 400, // Provide a fixed height
      child: ListView.builder(
        itemCount: apiData.length,
        itemBuilder: (context, index) {
          final item = apiData[index];
          return ListTile(
            title: Text(item ?? 'Không có tên'),
          );
        },
      ),
    );
  }
}