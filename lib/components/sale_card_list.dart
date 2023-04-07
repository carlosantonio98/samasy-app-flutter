import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/components/sale_card.dart';
import 'package:samasy_app/models/sale.dart';
import 'package:samasy_app/models/user.dart';
import 'package:samasy_app/services/api_services.dart';

import 'package:samasy_app/services/auth_services.dart';

import 'package:samasy_app/services/sale_services.dart';


class SaleCardList extends StatefulWidget {
  
  const SaleCardList({super.key});

  @override
  State<SaleCardList> createState() => _SaleCardListState();
}

class _SaleCardListState extends State<SaleCardList> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // cargamos los datos del user
  Future<void> _loadUserInfo() async {
    final authService = Provider.of<AuthServices>(context, listen: false);
    final token = authService.token;
    print(authService.token);

    try {
      final userJson = await ApiService().getUserInfo(token);

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

  @override
  Widget build(BuildContext context) {
    
    // indicamos que sea de tipo stream para que escuche cambion en los datos en realTime
    Future<List<Sale>> _getSales() async {
      final response = await SaleServices.getSales( _user?.id );

      List<Sale> sales = [];

      if (response.statusCode == 200) {

        String body = utf8.decode(response.bodyBytes); // se hace para que nos muestre bien los textos aunque traigan ñ o acentos.

        final jsonData = jsonDecode(body);

        for (var data in jsonData['data']) {
          sales.add(
            Sale(id: data['id'], name: data['name'], price: data['price'], created_at: data['created_at'])
          );
        }

        return sales;

      } else {
        throw Exception('Falló la conexión');
      }
    }

    final listTitle = Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        bottom: 20.0
      ),

      child: const Text(
        'Latest Sales',
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF1A1A1A)
        ),
      ),
    );

    List<Widget> _listSalesCard( data ) {
    
      List<Widget> sales = [ listTitle ];

      for (var sale in data) {
        sales.add(
          SaleCard(productName: sale.name, createdSale: sale.created_at, productPrice: sale.price.toString()),
        );
      }

      return sales;
    }

    return FutureBuilder<List<Sale>> (
      future: _getSales(),
      builder: (context, snapshot) {  // snapshot contiene todos los datos de nuestro future

        if ( snapshot.hasData ) { 

          return Container(
            margin: const EdgeInsets.only(
              top: 250.0
            ),
        
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _listSalesCard( snapshot.data )
            )
          );
        } else if (snapshot.hasError) {
          return const Text( 'Error' );
        }

        return const Center( child: CircularProgressIndicator() );  // para que salga el spinner cuando todavia no cargue nada
      },
    );
  }
}