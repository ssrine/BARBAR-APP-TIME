import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalonProfilePage extends StatefulWidget {
  @override
  _SalonProfilePageState createState() => _SalonProfilePageState();
}

class _SalonProfilePageState extends State<SalonProfilePage> {
  Map<String, dynamic>? _salonData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String username = ModalRoute.of(context)!.settings.arguments as String; // Get the username from arguments
    fetchSalonProfile(username);
  }

  Future<void> fetchSalonProfile(String username) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/salon-profile/$username/'));

    if (response.statusCode == 200) {
      setState(() {
        _salonData = json.decode(response.body);
      });
    } else {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load salon profile')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Return to salon_home
          },
        ),
      ),
      body: _salonData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Salon image
                  if (_salonData!['image'] != null)
                    Image.network(_salonData!['image'], height: 150, fit: BoxFit.cover),
                  SizedBox(height: 10),
                  // Salon details
                  _buildDetailCard('Full Name', _salonData!['full_name']),
                  _buildDetailCard('Salon Name', _salonData!['salon_name']),
                  _buildDetailCard('City', _salonData!['city']),
                  _buildDetailCard('Country', _salonData!['country']),
                  _buildDetailCard('Location', _salonData!['location']),
                  _buildDetailCard('Phone Number', _salonData!['phone_number']),
                  SizedBox(height: 20),
                  // Haircut Offers title
                  Text('Haircut Offers:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _salonData!['haircuts'].length,
                      itemBuilder: (context, index) {
                        final haircut = _salonData!['haircuts'][index];
                        return _buildHaircutCard(haircut);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Method to create a detail card
  Widget _buildDetailCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18)),
            Text(value, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  // Method to create a haircut card
  Widget _buildHaircutCard(Map<String, dynamic> haircut) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (haircut['image'] != null)
              Image.network(haircut['image'], width: 100, height: 100, fit: BoxFit.cover),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(haircut['name'], style: TextStyle(fontSize: 18)),
                  Text('Price: \$${haircut['price']}', style: TextStyle(fontSize: 16)),
                  Text('Duration: ${haircut['duration']} minutes', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
