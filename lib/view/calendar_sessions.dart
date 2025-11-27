import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/booking_model.dart';
import 'package:app_psikolog/view/bottom_navbar.dart';
import 'package:app_psikolog/view/home_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      controller.text =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
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
                _showSnackBar("Konsultasi berhasil ditambahkan!", Colors.blue);
                _loadBookings();
              } else {
                _showSnackBar("Semua field wajib diisi!", Colors.orange);
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
              onTap: () async => await _pickTime(waktuController),
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

  @override
  @override
Widget build(BuildContext context) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
  final filteredBookings =
      _bookings.where((b) => b.date == formattedDate).toList();

  return Scaffold(
    backgroundColor: const Color(0xfff8fabd4),

    appBar: AppBar(
      backgroundColor: const Color(0xFF0BA6DF),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const BottomNavbar()),
            (route) => false,
          );
        },
      ),
      title: const Text(
        "Consultation Calendar",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      onPressed: _addAppointment,
      child: const Icon(Icons.add),
    ),

    body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),

          // ===========================
          //  TEXTFIELD TAMPIL TANGGAL (TIDAK DAPAT DIKLIK)
          // ===========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: dateController,
              readOnly: true,
              enabled: false, // <<< tidak bisa diklik
              decoration: InputDecoration(
                labelText: "Tanggal Terpilih",
                prefixIcon: const Icon(Icons.calendar_today),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ===========================
          //  📌 KALENDER MUNCUL LANGSUNG
          // ===========================
          Container(
  margin: const EdgeInsets.symmetric(horizontal: 16),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 125, 179, 241),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.07),
        blurRadius: 8,
        offset: const Offset(0, 4),
      )
    ],
  ),
  child:Theme(
  data: Theme.of(context).copyWith(
    // Tambahkan warna font Judul Calendar
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  child: TableCalendar(
    focusedDay: selectedDate,
    firstDay: DateTime.utc(2020),
    lastDay: DateTime.utc(2030),

    selectedDayPredicate: (day) {
      return isSameDay(day, selectedDate);
    },

    onDaySelected: (selected, focused) {
      setState(() {
        selectedDate = selected;
        dateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    },

    // ============================
    // 🎨 STYLE KALENDER
    // ============================
    calendarStyle: CalendarStyle(
      // Hari Diseleksi → LINGKARAN HITAM
      selectedDecoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),

      // Teks hari yang dipilih
      selectedTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      // Teks hari normal
      defaultTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),

      // Hari ini → LINGKARAN BORDER MERAH
      todayDecoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red, width: 2),
      ),
    ),

    // ============================
    // 🎨 STYLE HEADER (bulan & tahun)
    // ============================
    headerStyle: const HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white, // warna judul bulan/tahun
      ),
      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
    ),

    // ============================
    // 🎨 STYLE HARI SENIN–MINGGU
    // ============================
    daysOfWeekStyle: const DaysOfWeekStyle(
      weekendStyle: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      weekdayStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),



),


          const SizedBox(height: 20),

          // ===========================
          //  LIST BOOKING
          // ===========================
          ...filteredBookings.map(
            (data) => Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () => _editAppointment(data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAppointment(data.id!),
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
