
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/copy/models%20copy/user.dart';

import 'package:samasy_app/pages/home_page.dart';
import 'package:samasy_app/pages/login_page.dart';
import 'package:samasy_app/pages/scanner_page.dart';
import 'package:samasy_app/providers/auth_provider.dart';
import 'package:samasy_app/providers/sale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const SettingsApp()
  );
}

class SettingsApp extends StatefulWidget {
  const SettingsApp({super.key});

  @override
  State<SettingsApp> createState() => _SettingsAppState();
}

class _SettingsAppState extends State<SettingsApp> {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (context) => AuthProvider() ),
        ChangeNotifierProvider( create: (context) => SaleProvider() ),
      ],
      child: MaterialApp(
        title: 'samasy app',
        debugShowCheckedModeBanner: false,
        routes: {
          'home':(context) => const HomePage(),
          'scanner':(context) => const ScannerPage(),
        },
        /* home: Scaffold(
          body: Consumer(
            builder: (context, AuthProvider userProvider, _) {
              switch (userProvider.status) {
                case AuthStatus.Uninitialized:
                  return const LoginPage();
                case AuthStatus.Authenticated:
                  return const HomePage();
                case AuthStatus.Authenticating:
                  return const LoginPage();
                case AuthStatus.Unauthenticated:
                  return const LoginPage();
              }
            },
          ),
        ), */
         home: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Some error has Occurred');
            } else if (snapshot.hasData) {
              final token = snapshot.data!.getString('token');
              if (token != null) {
                final authInfo = Provider.of<AuthProvider>(context);
                // authInfo.user =  Use(id: 1, name: 'TEST', email: 'test@test', token: 'ss') as User;  descomentar
                authInfo.status = AuthStatus.Authenticated;

                return HomePage();
              } else {
                return LoginPage();
              }
            } else {
              return LoginPage();
            }
          }
        ),
      )
    );
  }
}