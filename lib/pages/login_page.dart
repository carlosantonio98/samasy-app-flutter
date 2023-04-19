import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/services/auth_services.dart';

import 'package:samasy_app/services/globals.dart';
import 'package:http/http.dart' as http;


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
    final authService = Provider.of<AuthServices>(context);

    Future<void> _login() async {

      // Validamos desde el front que los campos no vengan vacíos 
      if (_email.isNotEmpty  && _password.isNotEmpty) {

        // Hacemos la petición de login y esperamos la respuesta
        final response = await authService.login(_email, _password);

        // Si el estatus es 422 recibimos el error o mensaje y los mostrasmos
        if (response!.statusCode == 422) {

          // Transformamos los datos que recibimos de respuesta
          Map<String, dynamic> responseMap = json.decode(response.body);

          var validationErrors = '';

          // Si existe algún error mostramos el error, si no, mostramos el mensaje que mandamos desde el back
          if (responseMap['errors'] != null) {

            // Obtenemos todos los mensajes de error y los guardamos en la variable validationErrors
            responseMap['errors'].forEach((field, errors) {
              errors.forEach((error) {
                validationErrors += '$error \n';
              });
            });
            
            errorSnackBar(context, validationErrors.trim());

          } else {
            validationErrors = responseMap['message'];
            errorSnackBar(context, validationErrors);  // 
          }

          // Si el estatus es 200 redirigimos al home y mostramos un mensaje de exito
        } else if (response.statusCode == 200) {

          Navigator.pushNamed(context, 'home');
          succesSnackBar(context, 'Login successfully');

          // Si es un estatus diferente mostramos el error desconocido
        } else {
          errorSnackBar(context, 'unknown error');
        }

        // Si alguno de los campos del front estan vacíos, muestro un mensaje
      } else {
        errorSnackBar(context, 'Enter all required fields');
      }

    }

    
    const logo = SizedBox(
      width: 85,
      height: 85,
      child: CircleAvatar(
        backgroundColor: Color(0xFFF3F3F3),
        child: Text(
          'Samasy.',
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0xFF1A1A1A)
          ),
        ),
      ),
    );

    final title = Column(
      children: <Widget>[
        Text(
          'Welcome back!',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF1A1A1A)
          ),
        ),
        Text(
          'Please enter your login',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFC3C0C1)
          ),
        )
      ],
    );


    final inputsForm = Column(
      children: <Widget>[
        TextField(
          decoration: const InputDecoration(
            hintText: 'email@google.com',
            contentPadding: EdgeInsets.symmetric( vertical: 20 )
          ),
          onChanged: (value) {
            _email = value;
          },
        ),
        SizedBox(height: 30,),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'password',
            contentPadding: EdgeInsets.symmetric( vertical: 20 )
          ),
          onChanged: (value) {
            _password = value;
          },
        ),
      ],
    );

    final buttonForm = SizedBox(
      width: double.infinity,
      height: 49,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFFD0E1CE)),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF1A1A1A),
          ),
        ),
        onPressed: () => _login(),
      ),
    );


    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(29),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo,
            SizedBox(height: 18,),
            title,
            SizedBox(height: 61,),
            inputsForm,
            SizedBox(height: 61,),
            buttonForm
          ],
        ),
      ),
    );
    
  }
}