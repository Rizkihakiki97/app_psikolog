// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  int? id;
  String name;
  String role; // Pasien / Psikolog
  int? usia;
  String? riwayat;
  String? lisensi;
  String? spesialisasi;
  String? jadwal;
  int aktif;
  String? foto;
  String? bio;
  String email;
  String password;

  UserModel({
    this.id,
    required this.name,
    required this.role,
    this.usia,
    this.riwayat,
    this.lisensi,
    this.spesialisasi,
    this.jadwal,
    this.aktif = 1,
    this.foto,
    this.bio,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'role': role,
      'usia': usia,
      'riwayat': riwayat,
      'lisensi': lisensi,
      'spesialisasi': spesialisasi,
      'jadwal': jadwal,
      'aktif': aktif,
      'foto': foto,
      'bio': bio,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      role: map['role'] as String,
      usia: map['usia'] != null ? map['usia'] as int : null,
      riwayat: map['riwayat'] != null ? map['riwayat'] as String : null,
      lisensi: map['lisensi'] != null ? map['lisensi'] as String : null,
      spesialisasi: map['spesialisasi'] != null
          ? map['spesialisasi'] as String
          : null,
      jadwal: map['jadwal'] != null ? map['jadwal'] as String : null,
      aktif: map['aktif'] as int,
      foto: map['foto'] != null ? map['foto'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
