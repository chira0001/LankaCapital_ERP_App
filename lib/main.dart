import 'package:flutter/material.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/onbordingScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NKRS App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Inter"),
      home: Onbordingscreen(),
      
    );
  }
}
