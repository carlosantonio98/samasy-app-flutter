import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/Services/auth_services.dart';
import 'package:samasy_app/Services/globals.dart';
import 'package:samasy_app/copy/models%20copy/user.dart';
import 'package:samasy_app/providers/auth_provider.dart';
import 'package:samasy_app/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final authInfo = Provider.of<AuthProvider>(context);

    loginPressed() async {
      /* authInfo.status = AuthStatus.Authenticating;   descomentar

      if (_email.isNotEmpty && _password.isNotEmpty) {
        http.Response response = await AuthServices.login(_email, _password);

        Map responseMap = jsonDecode(response.body);

        if (response.statusCode == 200) {
          User user = User(
            id:    responseMap['user']['id'], 
            name:  responseMap['user']['name'], 
            email: responseMap['user']['email'], 
            token: responseMap['token']
          );

          //authInfo.user = user;  descomentar
          authInfo.status = AuthStatus.Authenticated;

          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.setString('token', responseMap['token']);
          localStorage.setString('user', user.toJSON().toString());

          Navigator.pushNamed(context, 'home');

        } else {
          errorSnackBar(context, responseMap.values.first);
        }
      } else {
        errorSnackBar(context, 'enter all required fields');
      } */
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                onChanged: (value) {
                  _email = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
                onChanged: (value) {
                  _password = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              RoundedButton(
                btnText: 'LOG IN',
                onBtnPressed: () => loginPressed(),
              )
            ],
          ),
        ));
  }
}