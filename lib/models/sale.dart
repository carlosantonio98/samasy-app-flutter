class Sale {
  int id;
  String name;
  String price;
  String created_at;

  Sale({ required this.id, required this.name, required this.price, required this.created_at });

  factory Sale.fromJson(Map<String, dynamic> json) {
    print(json);
    return Sale(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      created_at: json['created_at'],
    );
  }
}