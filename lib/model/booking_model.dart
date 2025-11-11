class BookingModel {
  final int? id;
  final String doctorName;
  final String specialization;
  final String date;
  final String time;
  final bool active;

  BookingModel({
    this.id,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.active,
  });

  // Convert from Map (database) to object
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      doctorName: map['doctorName'],
      specialization: map['specialization'],
      date: map['date'],
      time: map['time'],
      active: map['active'] == 1, //  ubah dari int ke bool
    );
  }

  // Convert from object to Map (for database insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorName': doctorName,
      'specialization': specialization,
      'date': date,
      'time': time,
      'active': active ? 1 : 0, // ubah dari bool ke int
    };
  }
}
