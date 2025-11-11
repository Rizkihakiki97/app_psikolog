import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarSessionsPage extends StatefulWidget {
  const CalendarSessionsPage({super.key});

  @override
  State<CalendarSessionsPage> createState() => _CalendarSessionsPageState();
}

class _CalendarSessionsPageState extends State<CalendarSessionsPage> {
  DateTime selectedDate = DateTime.now();
  List<BookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final data = await DbHelper.getAllBookings();
      setState(() {
        _bookings = data;
      });
    } catch (e) {
      print("Error loading bookings: $e");
    }
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
      barrierDismissible: false,

      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

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
                final newBooking = BookingModel(
                  doctorName: dokter,
                  specialization: pasien,
                  date: DateFormat('yyyy-MM-dd').format(selectedDate),
                  time: waktu,
                  active: true,
                );

                await DbHelper.insertBooking(newBooking);

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

  void _editAppointment(BookingModel booking) {
    final pasienController = TextEditingController(
      text: booking.specialization,
    );
    final dokterController = TextEditingController(text: booking.doctorName);
    final waktuController = TextEditingController(text: booking.time);

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
              final updated = BookingModel(
                id: booking.id,
                doctorName: dokterController.text,
                specialization: pasienController.text,
                date: booking.date,
                time: waktuController.text,
                active: booking.active,
              );

              await DbHelper.updateBooking(updated);
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
              await DbHelper.deleteBooking(id);
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

    final filteredBookings = _bookings
        .where((b) => b.date == formattedDate)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xfff8fabd4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0BA6DF),
        centerTitle: true,
        // title: const Text("Consultation Calendar"),
      ),
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
              color: Color(0xFF0BA6DF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: const Column(
              children: [
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
              color: Color(0xffCDC1FF),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
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
            child: filteredBookings.isEmpty
                ? const Center(
                    child: Text(
                      "No sessions scheduled for this day.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final data = filteredBookings[index];
                      return Card(
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
                            data.specialization,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${data.doctorName} • ${data.time}',
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
                                onPressed: () => _deleteAppointment(data.id!),
                              ),
                            ],
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
