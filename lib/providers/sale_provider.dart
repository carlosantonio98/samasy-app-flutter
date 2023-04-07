
import 'package:flutter/material.dart';
import 'package:samasy_app/models/sale.dart';

class SaleProvider with ChangeNotifier {

  late String _totalMoney = '';
  late String _monthMoney = '';
  late String _dayMoney = '';

  String get totalMoney {
    return _totalMoney;
  }

  String get monthMoney {
    return _monthMoney;
  }
  
  String get dayMoney {
    return _dayMoney;
  }
  

  set totalMoney( String totalMoney ) {
    _totalMoney = totalMoney;
    notifyListeners();
  }
  
  set monthMoney( String monthMoney ) {
    _monthMoney = monthMoney;
    notifyListeners();
  }
  
  set dayMoney( String dayMoney ) {
    _dayMoney = dayMoney;
    notifyListeners();
  }

}