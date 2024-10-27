// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // Main widget for displaying Google Map
// class GoogleMapFlutter extends StatefulWidget {
//   const GoogleMapFlutter({super.key});

//   @override
//   State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
// }

// class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
//   // Initial location for the map's camera position (latitude and longitude)
//   LatLng myCurrentLocation = const LatLng(17.600019022973527, 78.41798278899657);
//   // LatLng myCurrentLocation = const LatLng(28.578382, 81.63359);

//   late GoogleMapController googleMapController;
//   Set<Marker> markers = {};

//   LatLng? userCoordinates;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         myLocationButtonEnabled: false,

//         markers: markers,
//         // Setting the controller when the map is created
//         onMapCreated: (GoogleMapController controller) {
//           googleMapController = controller;
//         },
//         // Initial camera position of the map
//         initialCameraPosition: CameraPosition(
//           target: myCurrentLocation,
//           zoom: 14,
//         ),
//       ),
//       // Floating action button to get user's current location
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.white,
//         child: const Icon(
//           Icons.my_location,
//           size: 30,
//         ),
//         onPressed: () async {
//           // Getting the current position of the user
//           Position position = await currentPosition();
//           userCoordinates = LatLng(position.latitude, position.longitude);

//           // Animating the camera to the user's current position
//           googleMapController.animateCamera(
//             CameraUpdate.newCameraPosition(
//               CameraPosition(
//                 target: LatLng(position.latitude, position.longitude),
//                 zoom: 14,
//               ),
//             ),
//           );

//           // Clearing existing markers
//           markers.clear();
//           // Adding a new marker at the user's current position
//           markers.add(
//             Marker(
//               markerId: const MarkerId('currentLocation'),
//               position: LatLng(position.latitude, position.longitude),
//             ),
//           );

//           // Refreshing the state to update the UI with new markers
//           setState(() {
//             print(userCoordinates);
//           });
//         },
//       ),
//     );
//   }

//   // Function to determine the user's current position
//   Future<Position> currentPosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Checking if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled');
//     }

//     // Checking the location permission status
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       // Requesting permission if it is denied
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error("Location permission denied");
//       }
//     }

//     // Handling the case where permission is permanently denied
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied');
//     }

//     // Getting the current position of the user
//     Position position = await Geolocator.getCurrentPosition();
//     return position;
//   }
// }


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng myCurrentLocation = const LatLng(17.600019022973527, 78.41798278899657);
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Polyline? polyline; // To store the polyline
  LatLng? userCoordinates;
  LatLng? destinationCoordinates; // To hold the searched destination coordinates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        markers: markers,
        polylines: polyline != null ? {polyline!} : {}, // Add polyline to the map
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 14,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          size: 30,
        ),
        onPressed: () async {
          Position position = await currentPosition();
          userCoordinates = LatLng(position.latitude, position.longitude);

          // Move camera to user's current position
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: userCoordinates!,
                zoom: 14,
              ),
            ),
          );

          // Clear existing markers and add current location marker
          markers.clear();
          markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: userCoordinates!,
            ),
          );

          setState(() {});
        },
      ),
      // Add a text field to search for destination
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search destination...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Call your search function here
                _searchDestination('Your Search Query');
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _searchDestination(String query) async {
    // Call your API or logic to get destination coordinates based on the query
    // For now, let's use static coordinates as an example (replace with your API call)
    // Assume we get this from the server based on the query
    destinationCoordinates = LatLng(17.619019022973527, 78.44798278899657); // Replace with your logic

    // Add marker for the destination
    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destinationCoordinates!,
      ),
    );

    // Create a polyline
    polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: [userCoordinates!, destinationCoordinates!],
      color: Colors.blue,
      width: 5,
    );

    // Animate camera to the destination
    googleMapController.animateCamera(
      CameraUpdate.newLatLng(destinationCoordinates!),
    );

    setState(() {});
  }

  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
