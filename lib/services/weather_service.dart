import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = '';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse('$_baseUrl?q=$city&units=metric&appid=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }


  static Future<List<Map<String, dynamic>>> fetch5DayForecast(
      String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['list'];

      // Group by day (filter 12:00 PM forecasts)
      final daily = list.where((item) => item['dt_txt'].contains('12:00:00'))
          .toList();

      return daily.map((e) =>
      {
        'date': e['dt_txt'],
        'tempMin': e['main']['temp_min'],
        'tempMax': e['main']['temp_max'],
        'weather': e['weather'][0]['main'], // e.g., "Clear", "Clouds", "Rain"
      }).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
