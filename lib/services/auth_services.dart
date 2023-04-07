import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:samasy_app/Services/globals.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices with ChangeNotifier {

  String _token = '';

  // Methods
  Future<bool?> login(String email, String password) async {
    Map data = {
      "email":    email,
      "password": password,
    };

    final response = await http.post(
      Uri.parse('${baseURL}auth/login'),
      body: data,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _saveToken(responseData['token']);
      notifyListeners();
      return true;
    } else {
      return false;
    }
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
    print('Token en isLoggedIn:' + _token);
    return _token != '';
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    _token = token;
    print('Token en saveToken:' + _token);
  }

  String get token => 'token:' + _token;
}
