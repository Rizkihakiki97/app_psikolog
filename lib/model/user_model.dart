class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? bio;
  final String? lisensi;
  final String? foto;
  final String? phone;
  final String password;
  final String? role;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.bio,
    this.lisensi,
    this.foto,
    this.phone,
    required this.password,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'lisensi': lisensi,
      'foto': foto,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'],
      lisensi: map['lisensi'],
      foto: map['foto'],
      phone: map['phone'],
      password: map['password'] ?? '',
      role: map['role'],
    );
  }
}
