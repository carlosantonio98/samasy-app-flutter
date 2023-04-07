class User {
  int id = 0;
  String name = '';
  String email = '';
  String token = '';

  User({ required this.id, required this.name, required this.email, required this.token });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'id':    id,
      'name':  name,
      'email': email,
      'token': token,
    };
  }
}