import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/session_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarSessionsPage extends StatefulWidget {
  const CalendarSessionsPage({super.key});

  @override
  State<CalendarSessionsPage> createState() => _CalendarSessionsPageState();
}

class _CalendarSessionsPageState extends State<CalendarSessionsPage> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final db = AppDatabase.instance;
    final data = await db.getBookings();
    setState(() {
      _bookings = data;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addAppointment() {
    String pasien = '';
    String dokter = '';
    String waktu = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Konsultasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Nama Pasien"),
              onChanged: (v) => pasien = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Nama Dokter"),
              onChanged: (v) => dokter = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Waktu"),
              onChanged: (v) => waktu = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (pasien.isNotEmpty && dokter.isNotEmpty && waktu.isNotEmpty) {
                await AppDatabase.instance.insertBooking({
                  'doctorName': dokter,
                  'specialization': pasien, // sementara isi dengan nama pasien
                  'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                  'time': waktu,
                  'active': 1,
                });

                Navigator.pop(context);
                _showSnackBar("Konsultasi berhasil ditambahkan!");
                _loadBookings();
              } else {
                _showSnackBar("Semua field wajib diisi!");
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _editAppointment(Map<String, dynamic> booking) {
    final pasienController = TextEditingController(
      text: booking['specialization'],
    );
    final dokterController = TextEditingController(text: booking['doctorName']);
    final waktuController = TextEditingController(text: booking['time']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Konsultasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pasienController,
              decoration: const InputDecoration(labelText: "Nama Pasien"),
            ),
            TextField(
              controller: dokterController,
              decoration: const InputDecoration(labelText: "Nama Dokter"),
            ),
            TextField(
              controller: waktuController,
              decoration: const InputDecoration(labelText: "Waktu"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await AppDatabase.instance.updateBooking({
                'id': booking['id'],
                'doctorName': dokterController.text,
                'specialization': pasienController.text,
                'date': booking['date'],
                'time': waktuController.text,
                'active': booking['active'],
              });
              Navigator.pop(context);
              _showSnackBar("Data konsultasi berhasil diperbarui!");
              _loadBookings();
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _deleteAppointment(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Konsultasi"),
        content: const Text(
          "Apakah Anda yakin ingin menghapus konsultasi ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await AppDatabase.instance.deleteBooking(id);
              Navigator.pop(context);
              _showSnackBar("Konsultasi berhasil dihapus!");
              _loadBookings();
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    List<Map<String, String>> sessions =
        SessionData.appointments[formattedDate] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(backgroundColor: Colors.blueAccent, centerTitle: true),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: _addAppointment,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              children: const [
                Text(
                  "Consultation Calendar",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Check and manage patient appointments",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onDateChanged: (date) => setState(() => selectedDate = date),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Appointments on ${DateFormat('EEEE, MMM d').format(selectedDate)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                _bookings
                    .where(
                      (b) =>
                          b['date'] ==
                          DateFormat('yyyy-MM-dd').format(selectedDate),
                    )
                    .toList()
                    .isEmpty
                ? const Center(
                    child: Text(
                      "No sessions scheduled for this day.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView(
                    children: _bookings
                        .where(
                          (b) =>
                              b['date'] ==
                              DateFormat('yyyy-MM-dd').format(selectedDate),
                        )
                        .map(
                          (data) => Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.person,
                                color: Colors.blueAccent,
                              ),
                              title: Text(
                                data['specialization'], // pasien
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                '${data['doctorName']} • ${data['time']}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    onPressed: () => _editAppointment(data),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _deleteAppointment(data['id']),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
