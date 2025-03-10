import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class SearchService {
  static Future<List<Map<String, dynamic>>> searchCity(String cityName) async {
    final url = Uri.parse("https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=5&language=en&format=json");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["results"] != null) {
        String debug = List<Map<String, dynamic>>.from(data["results"])[0]['name'];
        debugPrint(debug);
        return List<Map<String, dynamic>>.from(data["results"]);
      }
    }
    return [];
  }
}
