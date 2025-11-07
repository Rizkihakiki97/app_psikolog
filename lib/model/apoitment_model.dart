class Appointment {
  final int? id;
  final String patientName;
  final String psychologistName;
  final String date;
  final String time;
  final String? notes;

  Appointment({
    this.id,
    required this.patientName,
    required this.psychologistName,
    required this.date,
    required this.time,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'psychologistName': psychologistName,
      'date': date,
      'time': time,
      'notes': notes,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      patientName: map['patientName'],
      psychologistName: map['psychologistName'],
      date: map['date'],
      time: map['time'],
      notes: map['notes'],
    );
  }
}
