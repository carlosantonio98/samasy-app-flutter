import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:samasy_app/services/globals.dart';

class ApiService {
  Future<Map<String, dynamic>> getUserInfo(String token) async {
    final response = await http.get(
      Uri.parse('${baseURL}user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final userJson = json.decode(response.body);
      return userJson;
    } else {
      throw Exception('Error al cargar la información del usuario');
    }
  }

  // Otros métodos
}