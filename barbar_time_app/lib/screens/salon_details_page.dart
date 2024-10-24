import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalonDetailsPage extends StatefulWidget {
  @override
  _SalonDetailsPageState createState() => _SalonDetailsPageState();
}

class _SalonDetailsPageState extends State<SalonDetailsPage> {
  String? username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    username = ModalRoute.of(context)!.settings.arguments as String; // Get the username from arguments
    fetchSalonProfile(username!); // Fetch salon profile data
  }

  // Fetch salon profile based on the username
  Future<void> fetchSalonProfile(String username) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/haircut/$username/'));

    if (response.statusCode == 200) {
      final salonData = jsonDecode(response.body);
      print('Salon Profile: $salonData');
    } else {
      print('Failed to fetch salon profile: ${response.body}');
    }
  }

  final List<Map<String, dynamic>> haircutOptions = [
    {
      'image': 'assets/images/option2.png',
      'name': 'Classic Cut',
    },
    {
      'image': 'assets/images/logo.png',
      'name': 'Fade Cut',
    },
    {
      'image': 'assets/images/option4.png',
      'name': 'Buzz Cut',
    },
    {
      'image': 'assets/images/option5.png',
      'name': 'Long Layer Cut',
    },
    {
      'image': 'assets/images/option6.png',
      'name': 'Kids Cut',
    },
  ];

  // Modified to remove username parameter
  Future<void> addHaircutToSalon(double price, int duration, String name, String image) async {
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/haircut/add/$username/'), // Ensure you're using the correct URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'price': price,
        'duration': duration,
        'name': name,
        'image': image, // Send the image name/path
      }),
    );

    if (response.statusCode == 200) {
      print('Haircut added successfully');
    } else {
      print('Failed to add haircut: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Haircut to add to your profile!'),
      ),
      body: ListView.builder(
        itemCount: haircutOptions.length,
        itemBuilder: (context, index) {
          final haircut = haircutOptions[index];
          return Card(
            child: ListTile(
              leading: Image.asset(haircut['image'], width: 50, height: 50),
              title: Text(haircut['name']),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final TextEditingController priceController = TextEditingController();
                    final TextEditingController durationController = TextEditingController();

                    return AlertDialog(
                      title: Text('Customize Your Selection'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(haircut['image'], width: 400, height: 400),
                            SizedBox(height: 10),
                            Text('You selected: ${haircut['name']}'),
                            TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter Price',
                                hintText: 'e.g., 20.00',
                              ),
                            ),
                            TextField(
                              controller: durationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter Duration (min)',
                                hintText: 'e.g., 30',
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            final double? price = double.tryParse(priceController.text);
                            final int? duration = int.tryParse(durationController.text);

                            if (price != null && duration != null) {
                              // Call addHaircutToSalon without passing username
                              addHaircutToSalon(
                                price,              // Pass the price
                                duration,           // Pass the duration
                                haircut['name'],    // Pass the haircut name
                                haircut['image'],   // Pass the haircut image path
                              ).then((_) {
                                // Optionally, show a success message or update UI after adding
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Haircut added successfully!')),
                                );
                              }).catchError((error) {
                                // Handle error response
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to add haircut: $error')),
                                );
                              });

                              Navigator.of(context).pop(); // Close the dialog
                            } else {
                              // Show an error dialog if input is invalid
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Invalid Input'),
                                  content: Text('Please enter valid price and duration.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
