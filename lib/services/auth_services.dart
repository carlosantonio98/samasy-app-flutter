import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:samasy_app/Services/globals.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices with ChangeNotifier {

  String _token = '';

  // Methods
  Future<http.Response?> login(String email, String password) async {
    Map<String, dynamic> data = { "email":    email, "password": password };

    final response = await http.post(
      Uri.parse('${baseURL}auth/login'),
      body: json.encode(data),
      headers: headers
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body);
      _saveToken(token);
    }
  
    return response;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _token = '';
    notifyListeners();
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
