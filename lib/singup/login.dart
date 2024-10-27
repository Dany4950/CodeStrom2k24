// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pool_edge_codestrom/rider/homeScreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool showProgressBar = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     if (isLoggedIn) {
//       // Navigate to HomeScreen if already logged in
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => HomeScreen()));
//     }
//   }

//   Future<void> _login() async {
//     setState(() {
//       showProgressBar = true; // Show progress indicator
//     });

//     final userData = {
//       'email': emailController.text,
//       'password': passwordController.text,
//     };

//     try {
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:5000/api/login'), // Adjust your URL
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(userData),
//       );

//       if (response.statusCode == 200) {
//         // Save login status
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);

//         // Navigate to HomeScreen
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => HomeScreen()));
//       } else {
//         // Handle login error
//         final errorData = jsonDecode(response.body);
//         _showErrorDialog(errorData['error'] ?? 'Login failed');
//       }
//     } catch (e) {
//       print('Error: $e');
//       _showErrorDialog('Network error. Please try again.');
//     } finally {
//       setState(() {
//         showProgressBar = false; // Hide progress indicator
//       });
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text('Login'),
//             ),
//             SizedBox(height: 20),
//             showProgressBar ? CircularProgressIndicator() : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pool_edge_codestrom/pooler/homeScreen.dart'; // Adjust the import based on your folder structure
import 'package:pool_edge_codestrom/rider/bottomNav.dart';
import 'package:pool_edge_codestrom/rider/homeScreen.dart'; // Adjust the import based on your folder structure

import '../widget /c_text_field.dart'; // Adjust the import based on your folder structure

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for login fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showProgressBar = false; // Show/hide progress indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 40),
          Center(
            child: Text(
              "Login to Your Account",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 40),
          // Email input field
          SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: c_text_field(
              editingController: emailController,
              labeltext: 'Email',
              keyboard: TextInputType.emailAddress,
              isobscuretext: false,
              icon_color: const Color.fromARGB(255, 97, 15, 11),
              icondata: Icons.email,
            ),
          ),
          SizedBox(height: 20),
          // Password input field
          SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: c_text_field(
              editingController: passwordController,
              labeltext: 'Password',
              keyboard: TextInputType.text,
              isobscuretext: true,
              icon_color: const Color.fromARGB(255, 97, 15, 11),
              icondata: Icons.lock,
            ),
          ),
          SizedBox(height: 20),
          // Login button
          Container(
            height: 50,
            color: Colors.grey[200],
            width: MediaQuery.of(context).size.width - 260,
            child: InkWell(
              onTap: () async {
                setState(() {
                  showProgressBar = true; // Show progress indicator
                });

                // Prepare the data to send to the API
                final loginData = {
                  'email': emailController.text,
                  'password': passwordController.text,
                };

                try {
                  // Send data to the API
                  final response = await http.post(
                    Uri.parse(
                        'http://10.0.2.2:5000/api/login'), // Your Flask login API URL
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(loginData),
                  );

                  // Handle the API response
                  if (response.statusCode == 200) {
                    // Successfully logged in
                    final userData = jsonDecode(response.body);
                    // Navigate to the appropriate home screen based on user role
                    if (userData['is_rider']) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Bottomnav()), // Rider Home
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen()), // Pooler Home
                      );
                    }
                  } else {
                    // Show error message
                    final errorData = jsonDecode(response.body);
                    _showErrorDialog(
                        errorData['error'] ?? 'An unknown error occurred.');
                  }
                } catch (e) {
                  // Handle exceptions
                  print('Error: $e');
                  _showErrorDialog(
                      'Failed to connect to the server. Please try again.');
                } finally {
                  setState(() {
                    showProgressBar = false; // Hide progress indicator
                  });
                }
              },
              child: Center(child: Text("Login")),
            ),
          ),
          SizedBox(height: 20),
          // Show progress indicator
          showProgressBar
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                )
              : Container(),
        ]),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
