import 'dart:convert';

import 'package:samasy_app/models/sale.dart';

import 'package:samasy_app/Services/globals.dart';
import 'package:http/http.dart' as http;

class SaleServices {
  static Future<http.Response> getSales( userId ) async {

    final url = Uri.parse('${baseURL}sales/sales-by-user-id?user_id=${userId}');

    http.Response response = await http.get(
      url, 
      headers: headers,
    );

    return response;
  }

  static Future<http.Response> getSalesMoney( userId ) async {
    final url = Uri.parse('${baseURL}sales/sales-money-by-user-id?user_id=${userId}');

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    return response;
  }
}