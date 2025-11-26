import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/booking_model.dart';
import 'package:app_psikolog/pages/home_page.dart';
import 'package:app_psikolog/view/home_dashboard.dart';
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

  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
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

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(useMaterial3: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = "$hour:$minute";
    }
  }

  void _addAppointment() {
    String pasien = '';
    String dokter = '';
    String waktu = '';

    final waktuController = TextEditingController();

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
              controller: waktuController,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Waktu"),
              onTap: () async {
                await _pickTime(waktuController);
                waktu = waktuController.text;
              },
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
              if (pasien.isNotEmpty &&
                  dokter.isNotEmpty &&
                  waktu.isNotEmpty) {
                final newBooking = BookingModel(
                  doctorName: dokter,
                  specialization: pasien,
                  date: DateFormat('yyyy-MM-dd').format(selectedDate),
                  time: waktu,
                  active: true,
                );

                await DbHelper.insertBooking(newBooking);
                Navigator.pop(context);
                _showSnackBar(
                    "Konsultasi berhasil ditambahkan!", Colors.blueAccent);
                _loadBookings();
              } else {
                _showSnackBar(
                    "Semua field wajib diisi!", Colors.orangeAccent);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _editAppointment(BookingModel booking) {
    final pasienController =
        TextEditingController(text: booking.specialization);
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
              readOnly: true,
              decoration: const InputDecoration(labelText: "Waktu"),
              onTap: () async {
                await _pickTime(waktuController);
              },
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
              _showSnackBar("Data berhasil diperbarui!", Colors.green);
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
        content: const Text("Apakah Anda yakin ingin menghapus konsultasi ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DbHelper.deleteBooking(id);
              Navigator.pop(context);
              _showSnackBar("Konsultasi berhasil dihapus!", Colors.red);
              _loadBookings();
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(useMaterial3: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final filteredBookings =
        _bookings.where((b) => b.date == formattedDate).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff8fabd4),

      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF0BA6DF),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),

          //  FIX BACK BUTTON → ANTI LAYAR HITAM
          onPressed: () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>  HomePage(),
      ),
      (route) => false,
    );
  },
),
        title: Column(
          children: const [
            Text(
              "Consultation Calendar",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Check and manage patient appointments",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: Colors.blueAccent,
          onPressed: _addAppointment,
          child: const Icon(Icons.add, size: 28),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Pilih Tanggal",
                  suffixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onTap: _pickDate,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffCDC1FF),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8)
                ],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  datePickerTheme: DatePickerThemeData(
                    dayStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                    dayForegroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return Colors.black;
                    }),
                    dayBackgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xFF2196F3);
                      }
                      return Colors.transparent;
                    }),
                    todayBorder:
                        const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    });
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Appointments on ${DateFormat('EEEE, MMM d').format(selectedDate)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...filteredBookings.map(
              (data) => Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading:
                      const Icon(Icons.person, color: Colors.blueAccent),
                  title: Text(
                    data.specialization,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text("${data.doctorName} • ${data.time}",
                      style: const TextStyle(color: Colors.black54)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _editAppointment(data),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteAppointment(data.id!),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
