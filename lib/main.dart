import 'package:flutter/material.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/onbordingScreen.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/collection_entry.dart' show CollectionEntryPage;
import 'package:nkrs_app/views/customer_collection_views/loginpage/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NKRS App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Inter"),
      home: CollectionEntryPage(),
    );
  }
}
