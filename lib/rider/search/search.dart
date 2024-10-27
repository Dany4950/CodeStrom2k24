// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:pool_edge_codestrom/rider/homeScreen.dart';


// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _addressController = TextEditingController();
//   final String _apiUrl = 'http://10.0.2.2:5001/get_coordinates'; // Flask API endpoint

//   Future<void> _searchAddress() async {
//     final String address = _addressController.text;

//     try {
//       final response = await http.get(Uri.parse('$_apiUrl?address=$address'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
        
//         if (data.containsKey('coordinates')) {
//           final double lat = data['coordinates']['lat'];
//           final double lng = data['coordinates']['lng'];
//           _navigateToHomeScreen(LatLng(lat, lng), address);
//         } else {
//           _showError(data['error'] ?? 'No coordinates found');
//         }
//       } else {
//         _showError('Failed to fetch coordinates');
//       }
//     } catch (e) {
//       _showError('Error: $e');
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   void _navigateToHomeScreen(LatLng coordinates, String address) {
//     Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) => HomeScreen( coordinate, placeName: address),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Location'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _addressController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Address',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: _searchAddress,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }