import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samasy_app/rounded_button.dart';
import 'package:samasy_app/services/auth_services.dart';


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

    login() async {
      if (_email.isNotEmpty && _password.isNotEmpty) {
        bool? isLoggedIn = await authService.login(_email, _password);
        if (isLoggedIn != null) {
          // navegar a la pantalla de inicio después del inicio de sesión exitoso
          Navigator.pushNamed(context, 'scanner');
        } else {
          // mostrar un mensaje de error si el inicio de sesión falla
          print('ocurrio un error el la función login de LoginPage');
        }
      }
    }

    // XGECAR ESTE CÓDIGO DE ABAJO ESTE ES EL QUE PERMITE MOSTRAR EL ERRO EN EL SNACKBAR
    /* final authInfo = Provider.of<AuthProvider>(context);
    loginPressed() async {
      authInfo.status = AuthStatus.Authenticating;

      if (_email.isNotEmpty && _password.isNotEmpty) {
        http.Response response = await AuthServices.login(_email, _password);

        Map responseMap = jsonDecode(response.body);

        if (response.statusCode == 200) {
          User user = User(
            id:    responseMap['user']['id'], 
            name:  responseMap['user']['name'], 
            email: responseMap['user']['email'],
          );

          authInfo.user = user;
          authInfo.status = AuthStatus.Authenticated;

          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.setString('token', responseMap['token']);
          //localStorage.setString('user', user.toJSON().toString());

          Navigator.pushNamed(context, 'home');

        } else {
          errorSnackBar(context, responseMap.values.first);
        }
      } else {
        errorSnackBar(context, 'enter all required fields');
      }
    } */

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
                onBtnPressed: () => login(),
              )
            ],
          ),
        ));
  }
}