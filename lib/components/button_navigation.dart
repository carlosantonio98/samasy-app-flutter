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

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({super.key});

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
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



  Future<void> _saleRegister(int productId) async {

    try {

      final response = await ApiService().newSale(productId, _user!.id, _token!);

      Map<String, dynamic> responseMap = json.decode(response.body);

      if (response.statusCode == 422) {
        errorSnackBar(context, responseMap['message']);
      } else if (response.statusCode == 201) {
        succesSnackBar(context, responseMap['message']);
      } else {
        errorSnackBar(context, 'unknown error');
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

    _saleRegister(int.parse(barcodeScanRes));

  }




  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.35,
      height: 49.0,

      margin: const EdgeInsets.only(
        bottom: 20.0
      ),

      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.all(
          Radius.circular(31.0)
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(
              Icons.home, 
              color: Color(0xFFC3E6EA)
            )
          ),
          

          IconButton(
            onPressed: () {
              scanQR();
            },
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Color(0xFFF8F8F8)
            )
          )
        ],
      ),
    );
  }
}