import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // Confirm Password
  final _emailController = TextEditingController(); // Optional for email
  final _phoneController = TextEditingController(); // Phone Number
  final _fullNameController = TextEditingController(); // Full Name (for salon)
  final _salonNameController = TextEditingController(); // Salon Name
  final _cityController = TextEditingController(); // City
  final _countryController = TextEditingController(); // Country
  final _locationController = TextEditingController(); // Location
  String _accountType = 'customer'; // Default account type
  String _otpToken = ''; // Variable to hold OTP

  Future<void> _signUp() async {
    final Map<String, dynamic> body;

    if (_accountType == 'customer') {
      body = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'password': _passwordController.text,
        'confirm_password': _confirmPasswordController.text,
        'account_type': _accountType,
      };
    } else { // Salon
      body = {
        'username': _usernameController.text, // Add username for salon
        'full_name': _fullNameController.text,
        'salon_name': _salonNameController.text,
        'city': _cityController.text,
        'country': _countryController.text,
        'location': _locationController.text,
        'phone_number': _phoneController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'confirm_password': _confirmPasswordController.text,
        'account_type': _accountType,
      };
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/signup/'), // Django signup endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      // Account created successfully, show OTP dialog
      _showOtpDialog();
    } else {
      // Handle error
      final body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['error'] ?? 'Signup failed!')));
    }
  }

  Future<void> _verifyOtp(BuildContext dialogContext) async {
    print("Verifying OTP: $_otpToken for user: ${_usernameController.text}");

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/verify-2fa/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'otp_token': _otpToken,
        'username': _usernameController.text,
      }),
    );

    if (response.statusCode == 200) {
      print("OTP verified, proceeding to home page");
      Navigator.of(dialogContext).pop(); 
      Navigator.pushReplacementNamed(context, '/salon_home'); // Navigate to HomeScreen using named route
    } else {
      ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('OTP verification failed!')));
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            onChanged: (value) {
              _otpToken = value;
            },
            decoration: InputDecoration(hintText: 'OTP'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _verifyOtp(context); // Pass the dialog context
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align to start for better layout
              crossAxisAlignment: CrossAxisAlignment.stretch, // Make children stretch to full width
              children: [
                if (_accountType == 'customer') ...[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 16), // Space between fields
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email (optional)'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                ] else if (_accountType == 'salon') ...[
                  TextField(
                    controller: _usernameController, // Add username for salon
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                  ),
                  TextField(
                    controller: _salonNameController,
                    decoration: InputDecoration(labelText: 'Salon Name'),
                  ),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: 'City'),
                  ),
                  TextField(
                    controller: _countryController,
                    decoration: InputDecoration(labelText: 'Country'),
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email (optional)'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                ],
                SizedBox(height: 20), // Add some space
                // Account Type Selection
                Text('Select Account Type:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: 'customer',
                      groupValue: _accountType,
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });
                      },
                    ),
                    Text('Customer'),
                    Radio<String>(
                      value: 'salon',
                      groupValue: _accountType,
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });
                      },
                    ),
                    Text('Salon'),
                  ],
                ),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
