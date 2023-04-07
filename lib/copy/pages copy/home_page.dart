import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/components/button_navigation.dart';
import 'package:samasy_app/components/hero_home.dart';
import 'package:samasy_app/components/sale_card_list.dart';
import 'package:samasy_app/providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget> [
          ListView(
            children: const <Widget> [
              SaleCardList(),
            ],
          ),

          HeroHome(),

          ButtonNavigation()
        ],
      ),
    );
  }
}