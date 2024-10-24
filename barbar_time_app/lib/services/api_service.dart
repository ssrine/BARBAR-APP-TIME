import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';
import '../models/appointment.dart';
import '../models/salon.dart';
import '../models/payment.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/'; 

  // Get Customer by ID
  Future<Customer?> getCustomer(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customers/$id/'));

      if (response.statusCode == 200) {
        return Customer.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load customer: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching customer: $e');
      return null;
    }
  }

  // Create Appointment
  Future<Appointment?> createAppointment(int customerId, DateTime appointmentTime) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}appointments/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'customer_id': customerId,
          'appointment_time': appointmentTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return Appointment.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create appointment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while creating appointment: $e');
      return null;
    }
  }

  // List Appointments
  Future<List<Appointment>> listAppointments() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}appointments/'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Appointment.fromJson(item)).toList();
      } else {
        print('Error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      print('Exception occurred while loading appointments: $e');
      throw Exception('Failed to load appointments');
    }
  }

// Update the method to list customers
Future<List<Customer>> listCustomers() async {
  try {
    final response = await http.get(Uri.parse('${baseUrl}customers/')); // Make sure this matches your Django URL
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Customer.fromJson(item)).toList();
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load customers');
    }
  } catch (e) {
    print('Exception occurred: $e');
    throw Exception('Failed to load customers');
  }
}
  // Create Payment
// List Payments
Future<List<Payment>> listPayments() async {
  try {
    final response = await http.get(Uri.parse('${baseUrl}payments/'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Payment.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load payments: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<Payment?> createPayment(int customerId, double amount) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}payments/create/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'customer_id': customerId,
        'amount': amount,
      }),
    );

    if (response.statusCode == 201) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create payment: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}


Future<List<Salon>> listSalons() async {
  try {
    final response = await http.get(Uri.parse('${baseUrl}salons/'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Salon.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load salons: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

}
