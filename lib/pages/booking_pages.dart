import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/booking_model.dart';
import 'package:flutter/material.dart';

// import '../db/app_database.dart';
// import '../models/booking_model.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<BookingModel> bookings = [];
  final nameCtrl = TextEditingController();
  final specCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  bool active = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('bookings');
    setState(() {
      bookings = maps.map((e) => BookingModel.fromMap(e)).toList();
    });
  }

  Future<void> _addBooking() async {
    if (nameCtrl.text.isEmpty || specCtrl.text.isEmpty) return;
    final db = await AppDatabase.instance.database;
    await db.insert('bookings', {
      'doctorName': nameCtrl.text,
      'specialization': specCtrl.text,
      'date': dateCtrl.text,
      'time': timeCtrl.text,
      'active': active ? 1 : 0,
    });
    nameCtrl.clear();
    specCtrl.clear();
    dateCtrl.clear();
    timeCtrl.clear();
    _fetchBookings();
  }

  Future<void> _deleteBooking(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
    _fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Doctor Bookings')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Doctor Name'),
                ),
                TextField(
                  controller: specCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                  ),
                ),
                TextField(
                  controller: dateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                  ),
                ),
                TextField(
                  controller: timeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Time (e.g. 14:00)',
                  ),
                ),
                SwitchListTile(
                  title: const Text('Active Status'),
                  value: active,
                  onChanged: (val) => setState(() => active = val),
                ),
                ElevatedButton(
                  onPressed: _addBooking,
                  child: const Text('Add Booking'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, i) {
                final b = bookings[i];
                return ListTile(
                  leading: Icon(
                    b.active ? Icons.circle : Icons.circle_outlined,
                    color: b.active ? Colors.green : Colors.grey,
                  ),
                  title: Text('${b.doctorName} (${b.specialization})'),
                  subtitle: Text('${b.date} • ${b.time}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteBooking(b.id!),
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
