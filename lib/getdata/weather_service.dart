import 'dart:convert';
import 'package:http/http.dart' as http;

//lấy dữ liệu thời tiết từ OpenWeatherMap
class WeatherService {
  final String apiKey = '6eebf660bd3f5be5a577a873e4f8bf1a'; 
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  
  Future<Map<String, dynamic>> fetchWeather(String city) async {
  final response = await http.get(
    Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric') //  units=metric => trả về celsius
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}

}