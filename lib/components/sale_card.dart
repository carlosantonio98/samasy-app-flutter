import 'package:flutter/material.dart';

class SaleCard extends StatelessWidget {
  String productName = 'Agua de melón';
  String productPrice = '15.00';
  String createdSale = '10:00';

  SaleCard({required this.productName, required this.productPrice, required this.createdSale, super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final name = Text(
      productName,
      style: const TextStyle(
        fontSize: 11.0,
        color: Color(0xFF1A1A1A)
      ),
    );

    final time = Row(
      children: <Widget> [
        const Icon(
          Icons.access_time_filled,
          size: 11.0,
          color: Color(0xFFC3C0C1)
        ),

        Text(
          createdSale,
          style: const TextStyle(
            fontSize: 11.0,
            color: Color(0xFFC3C0C1)
          ),
        )
      ],
    );

    final priceSale = Text(
      '+\$$productPrice',
      style: const TextStyle(
        color: Color(0xFF91A28F),
        fontSize: 16.0
      ),
    );

    
    return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        bottom: 20.0,
        right: 20.0
      ),

      width: size.width,
      height: 70.0,

      decoration: const BoxDecoration(
        color: Color(0xFFF3F3F3),
        borderRadius: BorderRadius.all( Radius.circular(5.0) ),
      ),

      child: ListTile(
        title: name,
        subtitle: time,
        trailing: priceSale,
      ),
    );
  }
}