// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
    return <String, dynamic>{
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
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      email: map['email'] as String,
      bio: map['bio'] != null ? map['bio'] as String : null,
      lisensi: map['lisensi'] != null ? map['lisensi'] as String : null,
      foto: map['foto'] != null ? map['foto'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] as String,
      role: map['role'] != null ? map['role'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
