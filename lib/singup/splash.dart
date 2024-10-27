import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pool_edge_codestrom/singup/registration.dart';

// class Splash extends StatefulWidget {
//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   @override
//   Widget build(BuildContext context) {
//     Timer(Duration(seconds: 4), () {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => Registration()));
//     });
//     return Column(
//       children: [
//         Container(
//           child: Text("Splash Screen"),
//         )
//       ],
//     );
//   }
// }

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset(
        'assets/animation/Animation - 1729931552461.json',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      nextScreen: RegistrationScreen(),
      duration: 3500,
      backgroundColor: Colors.grey.shade200,
    );
  }
}
