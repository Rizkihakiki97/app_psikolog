class UserModel {
  String id;
  String nama;
  String role; // Pasien / Psikolog
  int? usia;
  String? riwayat;
  String? lisensi;
  String? spesialisasi;
  String? jadwal;
  bool aktif;
  String? foto;

  UserModel({
    required this.id,
    required this.nama,
    required this.role,
    this.usia,
    this.riwayat,
    this.lisensi,
    this.spesialisasi,
    this.jadwal,
    this.aktif = true,
    this.foto,
  });
}
