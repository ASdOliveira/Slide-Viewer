import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import '../injuriesGroup.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Clean Code',
        home: AnimatedSplashScreen(
            duration: 2500,
            splashIconSize: 500,
            splash: Image.asset(
              'assets/images/logo.png',
              height: 200,
              width: 205,
            ),
            nextScreen: InjuriesGroup(),
            splashTransition: SplashTransition.fadeTransition,
            animationDuration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 149, 48, 121)));
  }
}
