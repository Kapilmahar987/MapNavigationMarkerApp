import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:maps_flutter_project/user_current_Location.dart';

void main() {
  log("main is called");
  runApp(
      const MyApp()
  );

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log("Material App");

    return MaterialApp(
      home: UserCurrentLocation(),
    );
  }
}