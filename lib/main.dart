import 'package:flutter/material.dart';
import 'reusables/GasCard.dart';
import 'views/MainWindow.dart';
import 'package:degvielascenas/Settings.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(MyApp());

}



class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: data,
        debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
              splash: 'assets/logo.jpeg',
              nextScreen: MainWindow(),
              duration: 600,
              backgroundColor: Colors.white,
              splashTransition: SplashTransition.rotationTransition,

            )
    );
  }
}

