import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String email;
  final String phone;
  final int gender;
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

  String _getGenderText() {
    switch (gender) {
      case 1:
        return 'Nam';
      case 2:
        return 'Nữ';
      case 3:
        return 'Khác';
      default:
        return 'Chưa chọn';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 100,
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Xin chào, $name!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Email', email),
            _buildInfoRow('Số điện thoại', phone),
            _buildInfoRow('Giới tính', _getGenderText()),
            const SizedBox(height: 16),
            const Text(
              'Sở thích:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildHobbyRow('Âm nhạc', likeMusic),
            _buildHobbyRow('Phim ảnh', likeMovie),
            _buildHobbyRow('Sách', likeBook),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildHobbyRow(String hobby, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            hobby,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}