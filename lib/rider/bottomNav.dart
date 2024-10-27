import 'package:flutter/material.dart';
import 'package:pool_edge_codestrom/rider/billing.dart';

import 'package:pool_edge_codestrom/rider/homeScreen.dart';

class Bottomnav extends StatefulWidget {
 Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();




}

class _BottomnavState extends State<Bottomnav> {
    // List of pages for navigation
     int _selectedIndex = 0; // Cu
  final List<Widget> _pages = [
    HomeScreen(),
    Billing() ,
       // Home Page with Google Maps
 // Profile Page
  ];
    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Payments",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped, // Call the method on item tap
      ),

    );
  }
}