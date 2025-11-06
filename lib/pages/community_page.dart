import 'package:app_psikolog/pages/booking_pages.dart';
import 'package:app_psikolog/pages/role_pages.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // Fungsi dialog tambah booking
  void _showAddBookingDialog() {
    String pasien = '';
    String dokter = '';
    DateTime? tanggal;
    String waktu = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text("Tambah Booking Dokter"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: "Nama Pasien"),
                    onChanged: (v) => pasien = v,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(labelText: "Nama Dokter"),
                    onChanged: (v) => dokter = v,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setStateDialog(() {
                          tanggal = pickedDate;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Tanggal Booking",
                      ),
                      child: Text(
                        tanggal == null
                            ? "Pilih tanggal"
                            : "${tanggal!.day}/${tanggal!.month}/${tanggal!.year}",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Waktu (contoh: 14:00)",
                    ),
                    onChanged: (v) => waktu = v,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (pasien.isEmpty ||
                      dokter.isEmpty ||
                      tanggal == null ||
                      waktu.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Harap isi semua data booking."),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Booking berhasil untuk $pasien pada ${tanggal!.day}/${tanggal!.month}/${tanggal!.year} jam $waktu",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // 👉 Kalau mau langsung ke halaman booking:
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingPage()));
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.groups, size: 80, color: Colors.blue),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text("Manage User Roles"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RolePage()),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text("Add Booking"),
              onPressed: _showAddBookingDialog, // ✅ buka dialog tambah booking
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text("Lihat Semua Booking"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookingPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
