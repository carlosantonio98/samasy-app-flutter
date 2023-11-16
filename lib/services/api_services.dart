import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:samasy_app/config.dart';

class ApiService {
  Future<Map<String, dynamic>> getUserInfo(String token) async {
    final response = await http.get(
      Uri.parse('${SamasyConfig.baseURL}user'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      final userJson = json.decode(response.body);
      return userJson;
    } else {
      throw Exception('Error al cargar la información del usuario');
    }
  }

  // Otros métodos
  Future<Map<String, dynamic>> getSales(String token) async {
    final response = await http.get(
      Uri.parse('${SamasyConfig.baseURL}sales/all-sales'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final salesJson = json.decode(body);
      
      return salesJson;
    } else {
      throw Exception('Error al cargar la información de las ventas');
    }
  }

  Future<Map<String, dynamic>> getSalesMoney(String token) async {
    final response = await http.get(
      Uri.parse('${SamasyConfig.baseURL}sales/money-sales'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final moneyJson = json.decode(body);

      return moneyJson;
    } else {
      throw Exception('Error al cargar la información del dinero');
    }
  }
  
  Future<http.Response> newSale(int productId, int userId, String token) async {
    Map<String, dynamic> data = { "product_id": productId, "user_id": userId };

    final response = await http.post(
      Uri.parse('${SamasyConfig.baseURL}sales/new-sale'), 
      headers: { 'Authorization': 'Bearer $token', ...SamasyConfig.headers },
      body: json.encode(data)
    );

    return response;
  }
}