import 'package:flutter/material.dart';

class Onbordingscreen extends StatelessWidget {
  const Onbordingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              PageView(
                children: [
                  Container(color: Colors.red),
                  Container(color: const Color.fromARGB(255, 23, 198, 11)),
                  Container(color: const Color.fromARGB(255, 61, 26, 198)),
                  Container(color: const Color.fromARGB(255, 116, 19, 161)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
