enum UserRole { admin, guru, siswa }

class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final UserRole role;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'role': role.toString(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == json['role'],
      ),
    );
  }

  String getRoleName() {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.guru:
        return 'Guru';
      case UserRole.siswa:
        return 'Siswa';
    }
  }
}
