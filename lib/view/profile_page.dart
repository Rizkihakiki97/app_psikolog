import 'package:app_psikolog/view/editprofile.dart';
import 'package:app_psikolog/view/login_screen_mindcare.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header merah
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
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
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Card profil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
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
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        'assets/image/gambar/psikolog.png',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Rizky",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "muhammdhakiki97@email.com",
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "+62 896-1567-4013",
                      style: TextStyle(color: Colors.black45),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _ProfileStat(label: "Sessions", value: "24"),
                        _ProfileStat(label: "Active", value: "3"),
                        _ProfileStat(label: "Saved", value: "5"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Menu
            _ProfileMenu(
              icon: Icons.person_outlined,
              title: "Edit Profile",
              subtitle: "Update your personal information",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
              color: Colors.blue,
            ),
            _ProfileMenu(
              icon: Icons.calendar_today_outlined,
              title: "My Appointments",
              subtitle: "3 upcoming sessions",
              onTap: () {},
              color: Colors.red.shade300,
            ),
            _ProfileMenu(
              icon: Icons.favorite_border,
              title: "Saved Psychologists",
              subtitle: "5 saved",
              onTap: () {},
              color: Colors.yellow.shade300,
            ),
            _ProfileMenu(
              icon: Icons.help_outline,
              title: "Help Center",
              subtitle: "FAQs and support",
              onTap: () {},
              color: Colors.green.shade300,
            ),

            const SizedBox(height: 10),

            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Notifications",
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: true,
                          activeThumbColor: Colors.blueAccent,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SettingTile(
                    title: "Language",
                    value: "English",
                    onTap: () {},
                  ),
                  _SettingTile(title: "Terms & Conditions", onTap: () {}),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreenMindcare(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Versi
            const Text("Mindcare v1.0.6", style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// Widget untuk statistik
class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

// Widget untuk menu profil
class _ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _ProfileMenu({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk setting tile
class _SettingTile extends StatelessWidget {
  final String title;
  final String? value;
  final VoidCallback onTap;

  const _SettingTile({required this.title, this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              Row(
                children: [
                  if (value != null)
                    Text(value!, style: const TextStyle(color: Colors.grey)),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
