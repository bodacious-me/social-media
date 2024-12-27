class AppUser {
  final String id;
  final String email;
  final String name;

  AppUser({required this.email, required this.name, required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
        email: jsonUser['email'],
        name: jsonUser['name'],
        id: jsonUser['id']);
  }
}
