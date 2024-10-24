import 'package:flutter/material.dart';

class SalonHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the username from the arguments
    final String username = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Your Salon'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle any logout logic like clearing tokens or session
              Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Hello, $username!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('View Profile'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/salon_profile', arguments: username);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Offer'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/salon_details', arguments: username);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Manage Appointments'),
              onTap: () {
                Navigator.pushNamed(context, '/manage_appointments');
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('View Reports and Analytics'),
              onTap: () {
                Navigator.pushNamed(context, '/reports');
              },
            ),
            ListTile(
              leading: Icon(Icons.data_usage),
              title: Text('Manage Customer Data'),
              onTap: () {
                Navigator.pushNamed(context, '/secure_data');
              },
            ),
            Divider(), // Divider for better separation
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Your Salon!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Check if you have any reservations today.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to check reservations
                  Navigator.pushNamed(context, '/check_reservations');
                },
                child: Text('Check Reservations'),
              ),
              SizedBox(height: 20),
              Text(
                'Have a great day!',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
