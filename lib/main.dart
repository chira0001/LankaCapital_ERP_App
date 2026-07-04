import 'package:flutter/material.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/views/customer_collection_views/loginpage/login_page.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/app_lock_wrapper.dart';
import 'package:nkrs_app/data/services/auth_service.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/customer_collection_home.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/onbording_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CheckConnection.initialize();

  final authService = AuthService();
  final prefs = await SharedPreferences.getInstance();

  final bool isLoggedIn = await authService.isLoggedIn();

  // 'onboarding_seen' is set to true the first time the user completes
  // the onboarding flow. Default is false on a fresh install.
  final bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn, onboardingSeen: onboardingSeen));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool onboardingSeen;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.onboardingSeen,
  });

  @override
  Widget build(BuildContext context) {
    // Decision tree:
    //  ├─ Already logged in        → go straight to home (skip everything)
    //  ├─ First install            → show onboarding (user taps "Get Started" → login)
    //  └─ Onboarding already seen  → go straight to login
    Widget home;
    if (isLoggedIn) {
      home = const AppLockWrapper(child: CustomerCollectionHome());
    } else if (!onboardingSeen) {
      home = const Onbordingscreen();
    } else {
      home = const LoginPage();
    }

    return MaterialApp(
      title: "NKRS App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Inter"),
      home: home,
    );
  }
}
