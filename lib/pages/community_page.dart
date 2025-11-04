import 'package:app_psikolog/pages/booking_pages.dart';
import 'package:app_psikolog/pages/role_pages.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Community'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Ketika ikon Community diklik → tampil menu CRUD
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Community Options",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person),
                      label: const Text("Manage Roles"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RolePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      label: const Text("Manage Doctor Bookings"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BookingCrudPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.groups, size: 100, color: Colors.blue[600]),
              const SizedBox(height: 10),
              const Text(
                "Community",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
