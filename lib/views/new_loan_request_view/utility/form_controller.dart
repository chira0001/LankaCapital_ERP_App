import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextFormField(TextEditingController name, String s, TextInputType text, {
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autocorrect: false,
      cursorColor: const Color.fromARGB(255, 0, 55, 255),
      decoration: InputDecoration(
        floatingLabelStyle: const TextStyle(fontSize: 1),
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
          borderSide: const BorderSide(
            color: Color.fromARGB(58, 23, 23, 23),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
          borderSide: const BorderSide(
            color: Color.fromARGB(89, 181, 0, 0),
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: Color.fromARGB(255, 233, 1, 1),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        fillColor: safeAreaC, 
        filled: true,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color.fromARGB(105, 21, 21, 21),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      validator: validator,
    );
  }
}