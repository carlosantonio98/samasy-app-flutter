import 'package:flutter/material.dart';

const String baseURL = "http://samasy.iumovies.com/api/"; //emulator localhost
const Map<String, String> headers = {"Content-Type": "application/json", "Charset": "utf-8"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(seconds: 10),
  ));
}

succesSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(text),
    duration: const Duration(seconds: 10),
  ));
}