import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/role_model.dart';
import 'package:flutter/material.dart';
// import '../db/app_database.dart';
// import '../models/role_model.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  List<RoleModel> roles = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('roles');
    setState(() {
      roles = maps.map((e) => RoleModel.fromMap(e)).toList();
    });
  }

  Future<void> _addRole(String name) async {
    final db = await AppDatabase.instance.database;
    await db.insert('roles', {'name': name});
    controller.clear();
    _fetchRoles();
  }

  Future<void> _deleteRole(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete('roles', where: 'id = ?', whereArgs: [id]);
    _fetchRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage User Roles')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Role Name'),
                  ),
                ),
                IconButton(
                  onPressed: () => _addRole(controller.text),
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                final role = roles[index];
                return ListTile(
                  title: Text(role.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteRole(role.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
