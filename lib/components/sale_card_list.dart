import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/components/sale_card.dart';
import 'package:samasy_app/models/sale.dart';

import 'package:samasy_app/services/api_services.dart';
import 'package:samasy_app/services/auth_services.dart';

import 'package:intl/intl.dart';


class SaleCardList extends StatefulWidget {
  
  const SaleCardList({super.key});

  @override
  State<SaleCardList> createState() => _SaleCardListState();
}

class _SaleCardListState extends State<SaleCardList> {
  String? _token;

  Future<void> _loadUserToken() async {
    final authService = Provider.of<AuthServices>(context, listen: false);
    
    try {

      // Verifica que esta logueado y obtenemos el token del campo _token del provider, es necesario hacer esto para que se refresque en valor del token en el provider
      final isLoggedIn = await authService.isLoggedIn();

      if ( !isLoggedIn ) throw('Error: Is not logged');

      setState(() {
        _token = authService.token;
      });

    } catch (e) {
      throw('Error::::::' +  e.toString());
    }
  }


  Future<List<Sale>> _loadSales() async {
    List<Sale> sales = [];

    try {

      if (_token != null) {
        final salesJson =  await ApiService().getSales(_token!);

        for (var data in salesJson['data']) {
          String dateFormate = DateFormat("dd-MM-yyyy hh:mm").format(DateTime.parse(data['created_at']));

          Sale sale = Sale(id: data['id'], name: data['name'], price: data['price'].toString(), createdAt: dateFormate);

          sales.add(sale);
        }    
      }

      return sales;

    } catch (e) {
      throw ('Error:::::' + e.toString());
    }
  }


  @override
  void initState() {
    super.initState();
    _loadUserToken();
  }  
  
  @override
  Widget build(BuildContext context) {

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
          SaleCard(productName: sale.name, createdSale: sale.createdAt, productPrice: sale.price.toString()),
        );
      }

      return sales;
    }

    return FutureBuilder (
      future: _loadSales(),
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