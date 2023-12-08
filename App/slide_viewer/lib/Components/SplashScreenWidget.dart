import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '../injuriesGroup.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 2500,
        splashIconSize: 500,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 200,
              width: 205,
            ),
            SizedBox(height: 40),
            Text(
              "Guia de Patologia Oral",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFFFF)),
              textAlign: TextAlign.center,
            )
          ],
        ),
        nextScreen: InjuriesGroup(),
        splashTransition: SplashTransition.scaleTransition,
        animationDuration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF672855));
  }
}
