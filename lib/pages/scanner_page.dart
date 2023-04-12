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
  }

  Future<void> _loadUserToken() async {
    final authService = Provider.of<AuthServices>(context, listen: false);
    
    try {

      // Verifica que esta logueado y obtenemos el token del campo _token del provider, es necesario hacer esto para que se refresque en valor del token en el provider
      final isLoggedIn = await authService.isLoggedIn();

      if ( !isLoggedIn ) throw('Error: Is not logged');

      setState(() {
        _token = authService.token;
      });

      // permite obtener el usuario, con el _token actual, si ponemos las dos funciones asincrones en el initState estas no respetan el orden, obtienen los datos a como acaben
      _loadUserInfo();

    } catch (e) {
      throw('Error::::::' +  e.toString());
    }
  }



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
      throw('Error::::::' +  e.toString());
    }
  }



  Future<void> _saleRegister(productId) async {

    try {

      Map body = { 'product_id': productId, 'user_id': _user?.id };

      final response = await http.post(
        Uri.parse('${baseURL}sales/new-sale'), 
        headers: { 'Authorization': 'Bearer $_token', 'Content-Type': 'application/json', 'Accept': 'application/json', 'Charset': 'utf-8' },
        body: jsonEncode(body)
      );

      Map<String, dynamic> responseMap = json.decode(response.body);

      if (response.statusCode == 201) {
        succesSnackBar(context, responseMap['message']);
      } else { // recibimos el codigo 200 porque el 204 no trae el body y marca error al intentar hacer json.decode
        errorSnackBar(context, responseMap['message']);
      }

    } catch(e) {
      errorSnackBar(context, e.toString());
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
            (_user?.name != null) ? Text('Barcode: $_scanBarcode, Token: $_token') : CircularProgressIndicator(),

            SizedBox(height: 50.0),

            (_user?.name != null) ? Text('Bienvenido:' + _user!.name) : CircularProgressIndicator(),

            SizedBox(height: 50.0),

            ElevatedButton(
              onPressed: () {
                scanQR();
              }, 
              child: Text('Scan')
            ),
          ],
        ),
      ),
    );
  }
}