import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false; // Loading state for button
  String? _errorMessage; // Store error messages

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Start loading
      _errorMessage = null; // Clear previous error messages
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        // Show dialog to ask if the user is a salon owner
        _showUserTypeDialog();
      } else {
        setState(() {
          _errorMessage = 'Login failed! Please check your credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      await _googleSignIn.signIn();
      // Use Google token to authenticate with your backend
      final googleUser = _googleSignIn.currentUser;
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/google-login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'google_token': googleUser!.id, // Use the Google user token
        }),
      );

      if (response.statusCode == 200) {
        // Show dialog to ask if the user is a salon owner
        _showUserTypeDialog();
      } else {
        setState(() {
          _errorMessage = 'Google Login failed! Please try again.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error occurred while logging in with Google.';
      });
      print(error);
    }
  }

  void _showUserTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you a salon owner?'),
          content: Text('Please choose your type:'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  '/salon_home',
                  arguments: _usernameController.text.trim(), // Pass the username
                );
              },
              child: Text('Yes, I am a salon owner'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('No, I am a regular user'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Big title
              Text(
                'WELCOME TO BARBAR Time APP!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Customize color as needed
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Space between title and message
              Text(
                'Enjoy <3!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54, 
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30), 
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  errorText: _errorMessage != null ? ' ' : null, 
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _errorMessage != null ? ' ' : null, 
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              if (_errorMessage != null) 
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login, 
                child: _isLoading
                    ? CircularProgressIndicator() 
                    : Text('Login'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _loginWithGoogle, 
                icon: Icon(Icons.login),
                label: Text('Login with Google'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
