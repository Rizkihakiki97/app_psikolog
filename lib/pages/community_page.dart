import 'package:app_psikolog/pages/booking_pages.dart';
import 'package:app_psikolog/pages/role_pages.dart';
import 'package:flutter/material.dart';

// import 'role_crud_page.dart';
// import 'booking_crud_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
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
              label: const Text("Manage Doctor Bookings"),
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
