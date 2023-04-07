import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:samasy_app/services/globals.dart';


import 'package:provider/provider.dart';
import 'package:samasy_app/models/user.dart';
import 'package:samasy_app/services/auth_services.dart';

import '../services/api_services.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String _scanBarcode ='Unknown';
  
  User? _user;
  String? _token;

  @override
  void initState() {
    super.initState();
  
    _loadUserToken();
    //_loadUserInfo();  como no hay token fall
  }

  void _loadUserToken() {
    final authService = Provider.of<AuthServices>(context, listen: false);
    final token = authService.token;
    print('Token en el scanner:' + authService.token);

    setState(() {
     _token = token;
    });
  }


  /* void _loadUserToken() async {  no falla el token si antes seteamos el token con el isLoggedIn
    final authService = Provider.of<AuthServices>(context, listen: false);
    final token = authService.token;
    print('Token en el scanner:' + authService.token);
    
    final isLoggedIn = await authService.isLoggedIn();
    print('Isloggin en el scanner:' + isLoggedIn.toString());

    setState(() {
     _token = token;
    });
  } */




  Future<void> _loadUserInfo() async {

    try {
      final userJson = await ApiService().getUserInfo(_token!);

      setState(() {
        _user = User(
          id: userJson['id'],
          name: userJson['name'],
          email: userJson['email'],
        );
      });

    } catch (e) {
      print(e);
    }
  }



  Future<http.Response> _saleRegister(url) async {
    late http.Response response;
    print('entre1');

    try {
      print('entre2');

      var map = Map<String, dynamic>();
      map['product_id'] = '3';
      map['user_id'] = _user?.id;

      print(map);

      final response = await http.post(
        Uri.parse('${baseURL}sales/register-by-qr'), 
        headers: {'Authorization': 'bearer $_token', 'Content-Type': 'application/json', 'Accept': 'application/json', 'Charset': 'utf-8'},
        body: map
      );

      print('entre3');

      final dcode = json.decode(json.encode(response.body));

      print('Sale Response: $dcode');

      if (200 == response.statusCode) {
        return response;
      } else {
        throw 'Error fallo el registro';
      }

    } catch (e) {
      throw 'Error fallo el try';
    }

  }

  
  
  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancelar', false, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    _saleRegister(barcodeScanRes);

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }












  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Barcode: $_scanBarcode, Token: $_token'),
            ElevatedButton(
              onPressed: () {
                scanQR();
              }, 
              child: Text('Scan')
            ),
            ElevatedButton(
              onPressed: () {
              }, 
              child: Text('Load')
            ),
          ],
        ),
      ),
    );
  }
}