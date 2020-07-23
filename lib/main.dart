import 'package:flutter/material.dart';
import 'reusables/GasCard.dart';
import 'views/MainWindow.dart';
import 'package:degvielascenas/Settings.dart';
void main() {
  runApp(MyApp());

}



class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: data,
        debugShowCheckedModeBanner: false,
        home: MainWindow(),
    );
  }
}

