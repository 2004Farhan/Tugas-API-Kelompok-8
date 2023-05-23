import 'dart:convert';

import 'package:api_cuaca/cuaca.dart';
import 'package:http/http.dart' as http;

class DataService {
  Future<cuaca> fetchData(String cityName) async {
    try {
      // https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
      final queryParameters = {
        'q': cityName,
        'appid': 'e4b2057dc1c953be9043355664a278ab',
        'units': 'metric'
      };
      final uri = Uri.https(
          'api.openweathermap.org', 'data/2.5/weather', queryParameters);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return cuaca.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error status code');
      }
    } catch (e) {
      rethrow;
    }
  }
}
