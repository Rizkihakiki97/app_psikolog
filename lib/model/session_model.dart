// lib/models/session_data.dart;

class SessionData {
  // Global storage untuk semua jadwal konsultasi
  static Map<String, List<Map<String, String>>> appointments = {};

  // Fungsi untuk mendapatkan total semua sesi
  static int get totalSessions {
    int total = 0;
    for (var list in appointments.values) {
      total += list.length;
    }
    return total;
  }
}
