import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:samasy_app/config.dart';

class AuthServices with ChangeNotifier {

  String _token = '';

  // Methods
  Future<http.Response?> login(String email, String password) async {
    Map<String, dynamic> data = { "email":    email, "password": password };

    final response = await http.post(
      Uri.parse('${SamasyConfig.baseURL}auth/login'),
      body: json.encode(data),
      headers: SamasyConfig.headers
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body);
      _saveToken(token);
    }
  
    return response;
  }

  Future<http.Response?> logout() async {
    final response = await http.post(
      Uri.parse('${SamasyConfig.baseURL}auth/logout'),
      headers: {'Authorization': 'Bearer $_token', 'Accept': 'application/json', 'Charset': 'utf-8'},
    );

    if (response.statusCode == 204) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      _token = '';
      notifyListeners();
    }

    return response;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    notifyListeners();
    return _token != '';
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  String get token => _token;

}
