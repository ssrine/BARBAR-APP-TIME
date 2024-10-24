class Appointment {
  final int id;
  final String customer;
  final DateTime appointmentTime;

  Appointment({required this.id, required this.customer, required this.appointmentTime});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      customer: json['customer'],
      appointmentTime: DateTime.parse(json['appointment_time']),
    );
  }
}
