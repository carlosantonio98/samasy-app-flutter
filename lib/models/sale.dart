import 'package:intl/intl.dart';

class Sale {
  int id;
  String name;
  String price;
  String createdAt;

  Sale({ required this.id, required this.name, required this.price, required this.createdAt });

  factory Sale.fromJson(Map<String, dynamic> json) {
    String dateFormate = DateFormat("dd-MM-yyyy hh:mm").format(DateTime.parse(json['created_at']));

    return Sale(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      createdAt: dateFormate,
    );
  }
}