import 'dart:convert';
import 'package:http/http.dart' as http;

// Lớp dịch vụ để lấy dữ liệu tin tức từ NewsAPI
class NewsService {
  final String apiKey = 'a1b1533fbcd24730a988c71d092dad5f'; // API key
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  // Hàm để lấy các tiêu đề tin tức hàng đầu cho một quốc gia cụ thể
  Future<List<dynamic>> fetchTopHeadlines(String country) async {
    final response = await http.get(Uri.parse('$baseUrl?country=$country&apiKey=$apiKey'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}