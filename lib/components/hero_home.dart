import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/models/user.dart';
import 'package:samasy_app/services/auth_services.dart';
import 'package:samasy_app/services/sale_services.dart';

import '../services/api_services.dart';

class HeroHome extends StatefulWidget {
  HeroHome({super.key});

  @override
  State<HeroHome> createState() => _HeroHomeState();
}

class _HeroHomeState extends State<HeroHome> {
  User? _user;
  String _moneySales = '0';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final authService = Provider.of<AuthServices>(context, listen: false);
    final token = authService.token;

    try {
      final userJson = await ApiService().getUserInfo(token);

      setState(() {
        _user = User(
          id: userJson['id'],
          name: userJson['name'],
          email: userJson['email'],
        );
      });

      // Load sales all
      _loadSales();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadSales() async {
    final response = await SaleServices.getSalesMoney( _user?.id );

    if (response.statusCode == 200) {

      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      setState(() {
        _moneySales = jsonData['totalMoney'];
      });

    } else {
      throw Exception('Falló la conexión');
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final welcomeText = Text(
      'WELCOME, ${ _user?.name.toUpperCase() }',
      style: const TextStyle(
        fontSize: 14.0,
        color: Color(0xFFC3C0C1)
      ),
    );

    final symbol = Container(
      margin: const EdgeInsets.only(
        top: 8.0
      ),

      child: const Text(
        '\$',
        style: TextStyle(
          fontSize: 14.0
        ),
      ),
    );

    final totalMoney = Text(
      _moneySales,
      style: const TextStyle(
        fontSize: 40.0,
        color: Color(0xFF1A1A1A)
      ),
    );


    final background = Container(
      width: size.width,
      height: 225.0,

      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        boxShadow: <BoxShadow> [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15.0,
            offset: Offset(0.0, 5.0)  // el offset es como la posición de la sombre en x & y
          )
        ]
      ),
    );

    const logo = CircleAvatar(
      backgroundColor: Color(0xFFF3F3F3),
      child: Text(
        'SA.',
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF1A1A1A)
        ),
      ),
    );
  
    return Stack(
      children: <Widget> [
        background,

        Container(
          margin: const EdgeInsets.only(
            top: 120.0,
          ),

          child: Column(
            children: <Widget> [
              welcomeText,
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  symbol,

                  totalMoney
                ],
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(
            left: 20.0,
            top: 40.0
          ),

          child: logo,
        )
      ]
    );
  }
}