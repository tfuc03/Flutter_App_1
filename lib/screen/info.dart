import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String email;
  final String phone;
  final String gender;
  final bool likeMusic;
  final bool likeMovie;
  final bool likeBook;

  const Info({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.phone,
    required this.gender,
    required this.likeMusic,
    required this.likeMovie,
    required this.likeBook,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin người dùng')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (imageUrl.isNotEmpty)
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(imageUrl),
              )
            else
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 50),
              ),
            const SizedBox(height: 20),
            _buildInfoTile("Họ và tên", name),
            _buildInfoTile("Email", email),
            _buildInfoTile("Số điện thoại", phone),
            _buildInfoTile("Giới tính", gender),
            _buildInfoTile("Sở thích", _buildHobbyString()),
          ],
        ),
      ),
    );
  }

  String _buildHobbyString() {
    List<String> list = [];
    if (likeMusic) list.add("Âm nhạc");
    if (likeMovie) list.add("Phim ảnh");
    if (likeBook) list.add("Sách");
    return list.isEmpty ? "Không có" : list.join(", ");
  }

  Widget _buildInfoTile(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
