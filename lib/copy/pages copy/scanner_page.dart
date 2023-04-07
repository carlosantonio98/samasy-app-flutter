import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:samasy_app/models/sale.dart';
import 'package:samasy_app/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String _scanBarcode ='Unknown';

  Future<http.Response> _saleRegister(url) async {
    late http.Response response;
    print('entre1');

    Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8'
    };

    try {
      print('entre2');

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      final user = localStorage.getString("user");
      final userModel = jsonDecode(user!);

      var map = Map<String, dynamic>();
      map['product_id'] = '3';
      map['user_id'] = userModel.id;
      // map['token'] = '84|uSAgSjE8uqs0EANjaZtRcLBXUagSgkQIwNDIoxSC';
      map['token'] = userModel.token;

      print(map);

      final response = await http.post(
        Uri.parse('${baseURL}sales/register-by-qr'), 
        headers: headers,
        body: map
      );

      /* final response = await http.get(
        Uri.parse('https://samasy.cadeveloper.site/sales/register-by-qr?product_id=1&user_id=1'), 
        headers: {
          'Accept':'application/json'
        }
      ); */

      // necsito loguearme para que funcione por post
      /* final response = await http.post(
        Uri.parse('https://samasy.cadeveloper.site/admin/sales/register-by-qr'), 
        headers: {
          'Accept':'application/json'
        },
        body: map
      ); */

      // HACER EL LOGIN PARA QUE FUNCIONE EL PEDIDO DE DATOS

      print('entre3');

      final dcode = json.decode(json.encode(response.body));

      // fuciona si trae dato print('DECODE: ${ json.decode(json.encode(response.body)) }');
      //final conca = Sale.fromJson(dcode);

      print('Sale Response: ${dcode}');

      if (200 == response.statusCode) {
        return response;
      } else {
        throw 'Error fallo el registro';
      }

      /* response = await http.post(
        Uri.parse('$url?user_id=1'),
        body: {
          'product_id': '1',
          'user_id': '1'
        }
      ); */

      // Uri.parse('$url?user_id=1'),

      // print(jsonDecode(response.body));
    } catch (e) {
      throw 'Error fallo el try';
    }
    
    /* if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(jsonEncode(response.body));
      // Si la llamada al servidor fue exitosa, analiza el JSON
      print('Respuesta: $decodeResponse');
      return;
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load response');
    } */

    /* Map data = jsonDecode(response.body);

    print(data); */
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancelar', false, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
            Text('Resulta: $_scanBarcode&user_id=1'),
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