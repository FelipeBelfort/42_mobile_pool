import 'dart:convert';
import 'package:http/http.dart' as http;


class SearchService {

  static Future<List<Map<String, dynamic>>> searchByLocation(String location) async {
    final url = Uri.parse("http://api.openweathermap.org/geo/1.0/reverse?$location&limit=3&appid=6d7a30ec5c5eea7f9dc869f1a81e312e");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> searchCity(String cityName) async {
    final url = Uri.parse("https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=5&language=en&format=json");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["results"] != null) {
        return List<Map<String, dynamic>>.from(data["results"]);
      }
    }
    return [];
  }
}
