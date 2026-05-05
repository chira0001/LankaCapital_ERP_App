import 'package:flutter/material.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/onbordingScreen.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';

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
      // home:  Onbordingscreen(),
      home: LoanRequestSection(),
      // HomePage()
    );
  }
}
