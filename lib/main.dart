import 'package:flutter/material.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/onbordingScreen.dart';

import 'package:nkrs_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().setToken('eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzaGFudWthQGdtYWlsLmNvbSIsImlhdCI6MTc3ODIwOTc1NSwiZXhwIjoxNzc4MjExMTk1fQ.Zs9MDGnB8FC4XZwJy6MdOSehRz-k1rYhbBkiyhWaIAc');
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
      home: Onbordingscreen(),
      
    );
  }
}
