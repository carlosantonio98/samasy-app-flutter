import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/models/user.dart';
import 'package:samasy_app/services/auth_services.dart';

import '../services/api_services.dart';

class HeroHome extends StatefulWidget {
  HeroHome({super.key});

  @override
  State<HeroHome> createState() => _HeroHomeState();
}

class _HeroHomeState extends State<HeroHome> {
  User? _user;
  String? _moneySales;
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

      _loadSales();
    } catch (e) {
      print(e);
    }
  }

  
  Future<void> _loadSales() async {
    try {
      final moneyJson = await ApiService().getSalesMoney(_token!);

      setState(() {
        _moneySales = moneyJson['totalMoney'];
      });

    } catch (e) {
      print(e);
    }
  }

  
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final welcomeText = Text(
      'WELCOME, ${ _user?.name.toUpperCase() ?? '' }',
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
      _moneySales ?? '0.00',
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