import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:auto_fis/model/camera_model.dart';
import 'package:auto_fis/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/images/splash_animation.json'),
      nextScreen: MainScreen(camera: Provider.of<CameraModel>(context).selectedCamera!),
      splashIconSize: 300,
      duration: 2000,
      animationDuration: const Duration(seconds: 2),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
