


import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:pool_edge_codestrom/pooler/homeScreen.dart';
import 'package:pool_edge_codestrom/rider/homeScreen.dart';
import 'package:pool_edge_codestrom/singup/login.dart';
import 'package:pool_edge_codestrom/widget%20/c_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController institutionController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isRider = false;
  bool needsRide = false;
  bool showProgressBar = false;

  void handleSelection(String selection) {
    setState(() {
      if (selection == 'Rider') {
        isRider = true;
        needsRide = false;
      } else if (selection == 'Need a Ride') {
        needsRide = true;
        isRider = false;
      }
    });
  }

  // Check if all fields are filled
  bool _areAllFieldsFilled() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        institutionController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Center(
              child: Text(
                "Steps to Find your Match",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),
            // Personal info text fields
            _buildTextField(
                nameController, "Name", Icons.person, TextInputType.text),
            SizedBox(height: 20),
            _buildTextField(emailController, "Email", Icons.email,
                TextInputType.emailAddress),
            SizedBox(height: 20),
            _buildTextField(
                phoneController, "Phone", Icons.phone, TextInputType.number),
            SizedBox(height: 20),
            _buildTextField(institutionController, "Institution", Icons.school,
                TextInputType.text),
            SizedBox(height: 20),
            _buildTextField(
                passwordController, "Password", Icons.lock, TextInputType.text,
                obscureText: true),
            SizedBox(height: 20),
            // Toggle buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isRider ? Colors.green.shade300 : Colors.grey.shade200,
                  ),
                  onPressed: () => handleSelection('Rider'),
                  child: Text('Rider'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: needsRide
                        ? Colors.green.shade300
                        : Colors.grey.shade200,
                  ),
                  onPressed: () => handleSelection('Need a Ride'),
                  child: Text('Need a Ride'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Create Account button with validation
            Container(
              height: 50,
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width - 260,
              child: InkWell(
                onTap: () async {
                  if (!_areAllFieldsFilled()) {
                    // Show error message if any field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  setState(() {
                    showProgressBar = true;
                  });

                  // Prepare the data to send to the API
                  final userData = {
                    'username': nameController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                    'institution': institutionController.text,
                    'phone': phoneController.text,
                    'is_rider': isRider,
                  };

                  try {
                    // Send data to the API
                    final response = await http.post(
                      Uri.parse('http://10.0.2.2:5000/api/signup'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(userData),
                    );

                    // Handle the API response
                    if (response.statusCode == 201) {
                      if (isRider) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>HomeScreen()),
                        );
                      } else if (needsRide) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreenn()),
                        );
                      }
                    } else {
                      final errorData = jsonDecode(response.body);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text(errorData['error'] ??
                              'An unknown error occurred.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    print('Error: $e');
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Network Error'),
                        content: Text(
                            'Failed to connect to the server. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } finally {
                    setState(() {
                      showProgressBar = false;
                    });
                  }
                },
                child: Center(child: Text("Create Account")),
              ),
            ),
            SizedBox(height: 10),
            showProgressBar
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(width: 100),
                Text("Already a User ? "),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, TextInputType keyboardType,
      {bool obscureText = false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: c_text_field(
        editingController: controller,
        labeltext: label,
        keyboard: keyboardType,
        isobscuretext: obscureText,
        icon_color: const Color.fromARGB(255, 97, 15, 11),
        icondata: icon,
      ),
    );
  }
}
