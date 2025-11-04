import 'package:app_psikolog/view/calendar_sessions_page.dart'; // pastikan path ini sesuai dengan struktur project kamu
import 'package:flutter/material.dart';

class HomePageMindcare extends StatelessWidget {
  const HomePageMindcare({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER (Welcome)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
                decoration: const BoxDecoration(
                  color: Color(0xFF3D8BFF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Morning",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Hi, Rizky Hakiki",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(
                            "assets/image/gambar/psikolog.png",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: "Search psychologist...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Horizontal Menu (ubah jadi pakai GestureDetector)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _menuCard(
                          icon: Icons.chat_bubble_outline,
                          label: "Consult",
                          onTap: () {},
                        ),
                        _menuCard(
                          icon: Icons.calendar_today_outlined,
                          label: "Schedule",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CalendarSessionsPage(),
                              ),
                            );
                          },
                        ),
                        _menuCard(
                          icon: Icons.favorite_border,
                          label: "Tracker",
                          onTap: () {},
                        ),
                        _menuCard(
                          icon: Icons.people_outline,
                          label: "Community",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MOOD TRACKER CARD
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF3F8FF), Color(0xFFE7F0FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "How are you feeling?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Track your mood today",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3D8BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Check Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("", style: TextStyle(fontSize: 40)),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              //FEATURED PSYCHOLOGISTS
              _sectionHeader("Featured Psychologists"),
              _psychologistCard(
                image: "assets/image/gambar/dokter1.jpg",
                name: "Dr. Sarah Johnson",
                spec: "Clinical Psychologist",
                rating: 4.9,
                exp: "6 years",
              ),
              _psychologistCard(
                image: "assets/image/gambar/dokter2.png",
                name: "Dr. Lissa Chen",
                spec: "Cognitive Therapist",
                rating: 4.8,
                exp: "5 years",
              ),
              _psychologistCard(
                image: "assets/image/gambar/dokter3.jpg",
                name: "Dr. Emily Roberts",
                spec: "Family Therapy",
                rating: 4.7,
                exp: "7 years",
              ),

              const SizedBox(height: 25),

              //MENTAL HEALTH TIPS
              _sectionHeader("Mental Health Tips"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _tipCard(
                        image: "assets/image/gambar/orgil1.jpg",
                        title: "Managing Stress",
                        subtitle: "5 Min read",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _tipCard(
                        image: "assets/image/gambar/orgil2.jpg",
                        title: "Better Sleep",
                        subtitle: "5 Min read",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // REUSABLE COMPONENTS

  static Widget _menuCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF3D8BFF), size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "See All",
              style: TextStyle(color: Color(0xFF3D8BFF)),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _psychologistCard({
    required String image,
    required String name,
    required String spec,
    required double rating,
    required String exp,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(spec, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      "$rating  •  $exp",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _tipCard({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(subtitle),
        ],
      ),
    );
  }
}
