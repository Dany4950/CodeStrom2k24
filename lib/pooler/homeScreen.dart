import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:pool_edge_codestrom/rider/billing.dart';
import 'package:pool_edge_codestrom/rider/homeScreen.dart';
import 'package:pool_edge_codestrom/rider/live_location.dart';
import 'package:pool_edge_codestrom/rider/ride.dart';

import 'package:pool_edge_codestrom/singup/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen with Map',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreenn(),
    );
  }
}

class HomeScreenn extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenn> {
  StreamSubscription<Position>? _positionStreamSubscription;
  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1, // Update every 1 meter change
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    });
  }

  final List<Widget> _pages = [
    HomeScreen(), // Home Page with Google Maps
    Billing(), // Profile Page
  ];

  final TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};
  LatLng _currentPosition = LatLng(17.600019022973527, 78.41798278899657);
  GoogleMapController? _mapController;
  int _selectedIndex = 0;

  // Variable to store coordinates
  LatLng? _coordinates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.green[200],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("U", style: TextStyle(fontSize: 40.0)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'), //history
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Splash())),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GoogleMapFlutter()));
            },
            icon: Icon(Icons.location_on_sharp),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 60,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(30),
                ),
                height: 40,
                width: 250,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Enter Your Destination",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _searchPlace, // Trigger search on tap
                      icon: Icon(Icons.search),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoutePage(
                                  startPoint: LatLng(17.562878615534768,
                                      78.45632042950045), // Starting coordinate
                                  endPoint: LatLng(
                                      _coordinates!.latitude,
                                      _coordinates!
                                          .longitude), // Ending coordinate
                                ),
                              ));
                        },
                        child: Text("RIDE")),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 12,
              ),
              myLocationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchPlace() async {
    final String address = _searchController.text;
    final coordinates = await _getCoordinates(address);

    if (coordinates != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(coordinates));
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId(address),
            position: coordinates,
            infoWindow: InfoWindow(title: address),
          ),
        );

        // Store the coordinates in the variable
        _coordinates = coordinates;
        // Print the coordinates to the console
        print(
            'Coordinates: Lat: ${_coordinates!.latitude}, Lng: ${_coordinates!.longitude}');
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No results found')));
    }
  }

  Future<LatLng?> _getCoordinates(String address) async {
    // Ensure to use your correct IP address if testing on a physical device
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:5001/get_coordinates?address=${Uri.encodeComponent(address)}')); // Use 10.0.2.2 for emulator

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('coordinates')) {
        final lat = data['coordinates']['lat'];
        final lng = data['coordinates']['lng'];
        return LatLng(lat, lng);
      }
    }
    return null;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
