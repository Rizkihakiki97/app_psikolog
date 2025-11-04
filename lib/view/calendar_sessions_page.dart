import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarSessionsPage extends StatefulWidget {
  const CalendarSessionsPage({super.key});

  @override
  State<CalendarSessionsPage> createState() => _CalendarSessionsPageState();
}

class _CalendarSessionsPageState extends State<CalendarSessionsPage> {
  DateTime selectedDate = DateTime.now();

  // Data dummy jadwal pasien
  final Map<String, List<Map<String, String>>> sessions = {
    '2025-11-01': [
      {'name': 'Sarah Johnson', 'time': '09:00 AM'},
      {'name': 'Michael Chen', 'time': '01:30 PM'},
    ],
    '2025-11-02': [
      {'name': 'Emily Roberts', 'time': '10:15 AM'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    List<Map<String, String>> todaySessions = sessions[formattedDate] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FA),

      // ✅ AppBar dengan tombol panah kiri di atas "My Sessions Calendar"
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8BFF),
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context); // Kembali ke halaman sebelumnya
        //   },
        // ),
        title: const Text(
          "My Sessions Calendar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // ✅ Isi Halaman
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header biru
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF3D8BFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Check and manage patient appointments",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Kalender (Date Picker)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2026),
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Daftar Jadwal Hari Ini
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Appointments on ${DateFormat('EEEE, MMM d').format(selectedDate)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Jika tidak ada sesi
                    if (todaySessions.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No sessions scheduled for this day.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    // Jika ada sesi
                    else
                      Column(
                        children: todaySessions.map((session) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FBFD),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      session['name']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      session['time']!,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.video_call_rounded,
                                  color: Colors.blueAccent,
                                  size: 28,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
