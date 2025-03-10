import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Map<String, dynamic>> getWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return {};
  }
}
