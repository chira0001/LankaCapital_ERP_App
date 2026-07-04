import 'package:flutter/material.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/views/customer_collection_views/loginpage/login_page.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/app_lock_wrapper.dart';

import 'package:nkrs_app/data/services/auth_service.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/customer_collection_home.dart';

import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
// import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CheckConnection.initialize();
  final authService = AuthService();
  final isLoggedIn = await authService.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NKRS App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Inter"),
      //  home: LoanRequestSection(),
      // home: (),
      home: isLoggedIn
          ? const AppLockWrapper(child: CustomerCollectionHome())
          : const LoginPage(),

      // home: LoginPage(),
      // home: LoanRequestSection(),
      // home: isLoggedIn ? const AppLockWrapper(child: CustomerCollectionHome()) : const LoginPage(),
    );
  }
}
