import 'package:flutter/material.dart';
import 'appointments_page.dart';
import 'customer_page.dart';
import 'payments_page.dart';
import 'salons_page.dart';
import 'screens/salon_profile.dart'; // Make sure this exists
import 'screens/login_page.dart'; // Import LoginPage
import 'screens/signup_page.dart'; // Import SignUpPage
import 'screens/salon_home.dart'; // Import SalonHomePage
import 'screens/salon_details_page.dart'; // Import SalonDetailsPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false, // Disable the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomeScreen(),
        '/appointments': (context) => AppointmentsPage(),
        '/customers': (context) => CustomerPage(),
        '/payments': (context) => PaymentsPage(),
        '/salons': (context) => SalonsPage(),
        '/salon_home': (context) => SalonHomePage(), // Home page for salons
        '/salon_profile': (context) => SalonProfilePage(), // Correct route name for salon profile
        '/salon_details': (context) => SalonDetailsPage(), // Salon details page
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: const Color.fromARGB(255, 22, 32, 52),
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 33, 39),
              ),
            ),
            ListTile(
              title: Text('View Appointments'),
              onTap: () {
                Navigator.pushNamed(context, '/appointments');
              },
            ),
            ListTile(
              title: Text('View Customers'),
              onTap: () {
                Navigator.pushNamed(context, '/customers');
              },
            ),
            ListTile(
              title: Text('View Payments'),
              onTap: () {
                Navigator.pushNamed(context, '/payments');
              },
            ),
            ListTile(
              title: Text('View Salons'),
              onTap: () {
                Navigator.pushNamed(context, '/salons');
              },
            ),
            ListTile(
              title: Text('Logout'), // Optional Logout functionality
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
