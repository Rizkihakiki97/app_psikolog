class RoleModel {
  final int? id;
  final String name;

  RoleModel({this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  static RoleModel fromMap(Map<String, dynamic> map) =>
      RoleModel(id: map['id'], name: map['name']);
}
