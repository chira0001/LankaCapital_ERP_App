import 'package:flutter/material.dart';
import 'package:nkrs_app/Screens/OnBording/front_page.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"Expence",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Inter",
      ),
      home:FrontPage(),
    );
  }
}

