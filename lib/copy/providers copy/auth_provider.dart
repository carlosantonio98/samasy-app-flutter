
import 'package:flutter/material.dart';
import 'package:samasy_app/models/user.dart';


enum AuthStatus{
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class AuthProvider with ChangeNotifier {

  late User _user;

  // Set auth status to uninitialized
  AuthStatus _status = AuthStatus.Uninitialized;
  
  User get user {
    return _user;
  }
  
  set user( User user ) {
    _user = user;
    notifyListeners();
  }

  AuthStatus get status {
    return _status;
  }

  set status( AuthStatus status ) {
    _status = status;
    notifyListeners();
  } 
}