import 'package:flutter/material.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({super.key});

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
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
              Navigator.pushNamed(context, 'scanner');
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