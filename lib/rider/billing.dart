// import 'package:flutter/material.dart';

// class Billing extends StatefulWidget {
//   const Billing({super.key});

//   @override
//   State<Billing> createState() => _BillingState();
// }

// class _BillingState extends State<Billing> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Payments"),
//         backgroundColor: Colors.green[200],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             children: [
//               SizedBox(
//                 width: 40,
//               ),
//               Container(
//                 color: Colors.grey[300],
//                 height: 350,
//                 width: 300,
//                 child: Center(
//                     child: Text(
//                   "fare is 500",
//                   style: TextStyle(fontSize: 30),
//                 )),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Billing extends StatefulWidget {
  const Billing({super.key});

  @override
  State<Billing> createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    // Simulate a loading delay of 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isLoading = false; // Stop loading after 5 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
        backgroundColor: Colors.green[200],
      ),
      body: Center(
        // Centering the content
        child: isLoading
            ? CircularProgressIndicator()
            : Container(
                color: Colors.grey[300],
                height: 350,
                width: 300,
                child: Center(
                    child: Text(
                  "Fare is 500",
                  style: TextStyle(fontSize: 30),
                )),
              ),
      ),
    );
  }
}
