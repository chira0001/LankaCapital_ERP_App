import 'package:flutter/material.dart';

class SheredOnbording extends StatelessWidget {
  final String title;
  final String imageParth;
  final String description;

  const SheredOnbording({
    super.key,
    required this.title,
    required this.imageParth,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),

            const SizedBox(height: 20),

            // Image / Logo
            SizedBox(
              height: size.height * 0.35,
              child: Image.asset(imageParth, fit: BoxFit.contain),
            ),

            const SizedBox(height: 30),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5, // better readability
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
