// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class RoutePage extends StatefulWidget {
//   final LatLng startPoint;
//   final LatLng endPoint;

//   RoutePage({required this.startPoint, required this.endPoint});

//   @override
//   _RoutePageState createState() => _RoutePageState();
// }

// class _RoutePageState extends State<RoutePage> {
//   GoogleMapController? _mapController;
//   LatLng? _currentLocation;
//   Timer? _timer;
//   int _steps = 0;
//   Set<Polyline> _polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     _currentLocation = widget.startPoint;
//     _addPolyline();
//     _startNavigation();
//   }

//   void _addPolyline() {
//     _polylines.add(
//       Polyline(
//         polylineId: PolylineId('route'),
//         points: [widget.startPoint, widget.endPoint],
//         color: Colors.blue,
//         width: 5,
//       ),
//     );
//   }

//   void _startNavigation() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_steps <= 10) {
//         // Move 10 steps from start to end
//         _steps++;

//         double newLat = widget.startPoint.latitude +
//             (widget.endPoint.latitude - widget.startPoint.latitude) *
//                 (_steps / 10);
//         double newLng = widget.startPoint.longitude +
//             (widget.endPoint.longitude - widget.startPoint.longitude) *
//                 (_steps / 10);

//         _currentLocation = LatLng(newLat, newLng);

//         // Print the current location to the console
//         print(
//             'Current Location: Lat: ${_currentLocation!.latitude}, Lng: ${_currentLocation!.longitude}');

//         // Update the map camera position
//         _mapController
//             ?.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
//       } else {
//         // Stop the timer once we reach the end
//         _timer?.cancel();
//       }
//       // Force the map to redraw
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Route Navigation"),
//       ),
//       body: GoogleMap(
//         onMapCreated: (controller) {
//           _mapController = controller;
//           _mapController
//               ?.animateCamera(CameraUpdate.newLatLng(widget.startPoint));
//         },
//         initialCameraPosition: CameraPosition(
//           target: widget.startPoint,
//           zoom: 12,
//         ),
//         myLocationEnabled: true,
//         markers: {
//           Marker(
//             markerId: MarkerId("start"),
//             position: widget.startPoint,
//             infoWindow: InfoWindow(title: "Start"),
//           ),
//           Marker(
//             markerId: MarkerId("end"),
//             position: widget.endPoint,
//             infoWindow: InfoWindow(title: "End"),
//           ),
//           Marker(
//             markerId: MarkerId("current"),
//             position: _currentLocation ?? widget.startPoint,
//             infoWindow: InfoWindow(title: "Current Location"),
//           ),
//         },
//         polylines: _polylines,
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:pool_edge_codestrom/rider/billin.dart';
// import 'package:pool_edge_codestrom/rider/homeScreen.dart';

// class RoutePage extends StatefulWidget {
//   final LatLng startPoint;
//   final LatLng endPoint;

//   RoutePage({required this.startPoint, required this.endPoint});

//   @override
//   _RoutePageState createState() => _RoutePageState();
// }

// class _RoutePageState extends State<RoutePage> {
//   GoogleMapController? _mapController;
//   LatLng? _currentLocation;
//   Timer? _timer;
//   int _steps = 0;
//   Set<Polyline> _polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     _currentLocation = widget.startPoint;
//     _addPolyline();
//     _startNavigation();
//   }

//   void _addPolyline() {
//     _polylines.add(
//       Polyline(
//         polylineId: PolylineId('route'),
//         points: [widget.startPoint, widget.endPoint],
//         color: Colors.blue,
//         width: 5,
//       ),
//     );
//   }

//   void _startNavigation() {
//     // Set a timer that updates every second
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_steps < 10) {
//         // Move 10 steps from start to end
//         _steps++;

//         double newLat = widget.startPoint.latitude +
//             (widget.endPoint.latitude - widget.startPoint.latitude) *
//                 (_steps / 10);
//         double newLng = widget.startPoint.longitude +
//             (widget.endPoint.longitude - widget.startPoint.longitude) *
//                 (_steps / 10);

//         _currentLocation = LatLng(newLat, newLng);

//         // Print the current location to the console
//         print(
//             'Current Location: Lat: ${_currentLocation!.latitude}, Lng: ${_currentLocation!.longitude}');

//         // Update the map camera position
//         _mapController
//             ?.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
//       } else {
//         // Stop the timer once we reach the end
//         _timer?.cancel();
//         print(
//             "Reached destination: Lat: ${widget.endPoint.latitude}, Lng: ${widget.endPoint.longitude}");
//       }

//       // Force the map to redraw
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Route Navigation"),
//       ),
//       body: Column(
//         children: [
//           GoogleMap(
//             onMapCreated: (controller) {
//               _mapController = controller;
//               _mapController
//                   ?.animateCamera(CameraUpdate.newLatLng(widget.startPoint));
//             },
//             initialCameraPosition: CameraPosition(
//               target: widget.startPoint,
//               zoom: 12,
//             ),
//             myLocationEnabled: true,
//             markers: {
//               Marker(
//                 markerId: MarkerId("start"),
//                 position: widget.startPoint,
//                 infoWindow: InfoWindow(title: "Start"),
//               ),
//               Marker(
//                 markerId: MarkerId("end"),
//                 position: widget.endPoint,
//                 infoWindow: InfoWindow(title: "End"),
//               ),
//               Marker(
//                 markerId: MarkerId("current"),
//                 position: _currentLocation ?? widget.startPoint,
//                 infoWindow: InfoWindow(title: "Current Location"),
//               ),
//             },
//             polylines: _polylines,
//           ),
//           // ElevatedButton(
//           //     onPressed: () {
//           //       Navigator.push(context,
//           //           MaterialPageRoute(builder: (context) =>
//           //           Billing(c :Coordinates(_currentLocation!.latitude, _currentLocation!.longitude))));
//           //       ;
//           //     },
//           //     child: Text("Proceed to Pay ")),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:pool_edge_codestrom/rider/billing.dart';
import 'package:pool_edge_codestrom/rider/homeScreen.dart';

class RoutePage extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;

  RoutePage({required this.startPoint, required this.endPoint});

  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Timer? _timer;
  int _steps = 0;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.startPoint;
    _addPolyline();
    _startNavigation();
  }

  void _addPolyline() {
    _polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: [widget.startPoint, widget.endPoint],
        color: Colors.blue,
        width: 5,
      ),
    );
  }

  void _startNavigation() {
    // Set a timer that updates every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_steps < 10) {
        // Move 10 steps from start to end
        _steps++;

        double newLat = widget.startPoint.latitude +
            (widget.endPoint.latitude - widget.startPoint.latitude) *
                (_steps / 10);
        double newLng = widget.startPoint.longitude +
            (widget.endPoint.longitude - widget.startPoint.longitude) *
                (_steps / 10);

        _currentLocation = LatLng(newLat, newLng);

        // Print the current location to the console
        print(
            'Current Location: Lat: ${_currentLocation!.latitude}, Lng: ${_currentLocation!.longitude}');

        // Update the map camera position
        _mapController
            ?.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
      } else {
        // Stop the timer once we reach the end
        _timer?.cancel();
        print(
            "Reached destination: Lat: ${widget.endPoint.latitude}, Lng: ${widget.endPoint.longitude}");
      }

      // Force the map to redraw
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route Navigation"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController
                    ?.animateCamera(CameraUpdate.newLatLng(widget.startPoint));
              },
              initialCameraPosition: CameraPosition(
                target: widget.startPoint,
                zoom: 12,
              ),
              myLocationEnabled: true,
              markers: {
                Marker(
                  markerId: MarkerId("start"),
                  position: widget.startPoint,
                  infoWindow: InfoWindow(title: "Start"),
                ),
                Marker(
                  markerId: MarkerId("end"),
                  position: widget.endPoint,
                  infoWindow: InfoWindow(title: "End"),
                ),
                Marker(
                  markerId: MarkerId("current"),
                  position: _currentLocation ?? widget.startPoint,
                  infoWindow: InfoWindow(title: "Current Location"),
                ),
              },
              polylines: _polylines,
            ),
          ),
          ElevatedButton(
            onPressed: _currentLocation != null
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Billing(),
                      ),
                    );
                  }
                : null,
            child: Text("Proceed to Pay"),
          ),
        ],
      ),
    );
  }
}
