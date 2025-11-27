import 'package:flutter/material.dart';
import 'package:app_psikolog/model/booking_model.dart';
import 'package:app_psikolog/database/db_helper.dart';

class EditBookingPage extends StatefulWidget {
  final BookingModel booking;

  const EditBookingPage({super.key, required this.booking});

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController pasienController;
  late TextEditingController dokterController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    pasienController = TextEditingController(text: widget.booking.specialization);
    dokterController = TextEditingController(text: widget.booking.doctorName);
    timeController = TextEditingController(text: widget.booking.time);
  }

  _save() async {
    final updated = BookingModel(
      id: widget.booking.id,
      specialization: pasienController.text,
      doctorName: dokterController.text,
      date: widget.booking.date,
      time: timeController.text,
      active: widget.booking.active,
    );

    await DbHelper.updateBooking(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Booking"),
        backgroundColor: Colors.deepPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
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
              controller: timeController,
              decoration: const InputDecoration(labelText: "Waktu"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
