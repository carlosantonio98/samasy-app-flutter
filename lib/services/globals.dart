import 'package:flutter/material.dart';

const String baseURL = "TU_URL_DEL_SISTEMA_SAMASY";
const Map<String, String> headers = { "Content-Type": "application/json", "Accept": "application/json", "Charset": "utf-8" };

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}

succesSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}