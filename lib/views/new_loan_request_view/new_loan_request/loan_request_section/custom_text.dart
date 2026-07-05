import 'package:flutter/material.dart';

// ignore: camel_case_types
class customText extends StatelessWidget {
  final String label;

  const customText(String s, {super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(138, 26, 26, 26),
      ),
    );
  }
}
