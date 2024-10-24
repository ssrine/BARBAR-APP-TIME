import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalonsPage extends StatefulWidget {
  @override
  _SalonsPageState createState() => _SalonsPageState();
}

class _SalonsPageState extends State<SalonsPage> {
  List<dynamic> salons = [];

  @override
  void initState() {
    super.initState();
    fetchSalons();
  }

  Future<void> fetchSalons() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/salons/'));
      if (response.statusCode == 200) {
        setState(() {
          salons = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load salons');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salons'),
      ),
      body: salons.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : ListView.builder(
              itemCount: salons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(salons[index]['full_name']), // Use 'full_name' here
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('City: ${salons[index]['city']}'),
                      Text('Country: ${salons[index]['country']}'),
                      Text('Location: ${salons[index]['location']}'),
                      Text('Phone: ${salons[index]['phone_number']}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
