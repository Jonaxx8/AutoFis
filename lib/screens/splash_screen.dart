import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:auto_fis/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset(
            'assets/fisherma.jpg',
            width: 300,
            height: 300,
          ),
        ],
      ),
      nextScreen: const MainScreen(),
      splashIconSize: 300,
      duration: 3000,
      animationDuration: const Duration(seconds: 2),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}