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
            onPressed: () {
              if (pasien.isNotEmpty && dokter.isNotEmpty && waktu.isNotEmpty) {
                setState(() {
                  String key = DateFormat('yyyy-MM-dd').format(selectedDate);
                  SessionData.appointments.putIfAbsent(key, () => []);
                  SessionData.appointments[key]!.add({
                    'pasien': pasien,
                    'dokter': dokter,
                    'waktu': waktu,
                  });
                });
                Navigator.pop(context);
                _showSnackBar("Konsultasi berhasil ditambahkan!");
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

  void _editAppointment(int index) {
    String key = DateFormat('yyyy-MM-dd').format(selectedDate);
    var current = SessionData.appointments[key]![index];
    String pasien = current['pasien']!;
    String dokter = current['dokter']!;
    String waktu = current['waktu']!;

    final pasienController = TextEditingController(text: pasien);
    final dokterController = TextEditingController(text: dokter);
    final waktuController = TextEditingController(text: waktu);

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
            onPressed: () {
              setState(() {
                SessionData.appointments[key]![index] = {
                  'pasien': pasienController.text,
                  'dokter': dokterController.text,
                  'waktu': waktuController.text,
                };
              });
              Navigator.pop(context);
              _showSnackBar("Data konsultasi berhasil diperbarui!");
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _deleteAppointment(int index) {
    String key = DateFormat('yyyy-MM-dd').format(selectedDate);

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
            onPressed: () {
              setState(() {
                SessionData.appointments[key]!.removeAt(index);
              });
              Navigator.pop(context);
              _showSnackBar("Konsultasi berhasil dihapus!");
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
            child: sessions.isEmpty
                ? const Center(
                    child: Text(
                      "No sessions scheduled for this day.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      var data = sessions[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: const Icon(
                              Icons.person,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              data['pasien']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              '${data['dokter']} • ${data['waktu']}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => _editAppointment(index),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteAppointment(index),
                                ),
                              ],
                            ),
                          ),
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
