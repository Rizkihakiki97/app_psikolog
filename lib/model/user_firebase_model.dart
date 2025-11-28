import 'dart:convert';

class UserFirebaseModel {
  String? uid;
  String? username;
  String? email;
  String? phone;
  String? photo;
  String? bio;
  String? createdAt;
  String? updatedAt;

  UserFirebaseModel({
    this.uid,
    this.username,
    this.email,
    this.phone,
    this.photo,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'photo': photo,
      'bio': bio,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserFirebaseModel.fromMap(Map<String, dynamic> map) {
    return UserFirebaseModel(
      uid: map['uid'] as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      photo: map['photo'] as String?,
      bio: map['bio'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserFirebaseModel.fromJson(String source) =>
      UserFirebaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
