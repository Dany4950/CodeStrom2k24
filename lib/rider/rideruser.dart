// import 'package:flutter/material.dart';

// class Rideruser extends StatefulWidget {
//   const Rideruser({super.key});

//   @override
//   State<Rideruser> createState() => _RideruserState();
// }

// class _RideruserState extends State<Rideruser> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Column(
//         children: [

//         ],
//       ),
//     );
//   }
// }import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class RiderUser extends StatelessWidget {
  RiderUser({super.key});
  final List<Rider> riders = [
    Rider(
        name: 'John Doe',
        isAvailable: true,
        profilePictureUrl: 'https://via.placeholder.com/150'),
    Rider(
        name: 'Jane Smith',
        isAvailable: false,
        profilePictureUrl: 'https://via.placeholder.com/150'),
    Rider(
        name: 'Alex Johnson',
        isAvailable: true,
        profilePictureUrl: 'https://via.placeholder.com/150'),
    Rider(
        name: 'Emily Davis',
        isAvailable: false,
        profilePictureUrl: 'https://via.placeholder.com/150'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Availability'),
      ),
      body: ListView.builder(
        itemCount: riders.length,
        itemBuilder: (context, index) {
          final rider = riders[index];
          return RiderDetailContainer(rider: rider);
        },
      ),
    );
  }
}

class RiderDetailContainer extends StatelessWidget {
  final Rider rider;

  const RiderDetailContainer({Key? key, required this.rider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(rider.profilePictureUrl),
          radius: 30,
        ),
        title: Text(
          rider.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          rider.isAvailable ? 'Available' : 'Not Available',
          style: TextStyle(
            color: rider.isAvailable ? Colors.green : Colors.red,
          ),
        ),
        trailing: rider.isAvailable
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.cancel, color: Colors.red),
        onTap: () {
          // Action when the rider tile is tapped
          print('Tapped on ${rider.name}');
        },
      ),
    );
  }
}

class Rider {
  final String name;
  final bool isAvailable;
  final String profilePictureUrl;

  Rider({
    required this.name,
    required this.isAvailable,
    required this.profilePictureUrl,
  });
}
