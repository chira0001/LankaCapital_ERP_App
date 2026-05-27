import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final String hint;
  final double btnBorderRadius;
  final Color safeAreaC;

  const CustomDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hint,
    required this.btnBorderRadius,
    required this.safeAreaC,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      hint: Text(hint),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1A3D81)),
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(fontSize: 1),
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
          borderSide: BorderSide(
            color: Color.fromARGB(16, 50, 50, 50),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
          borderSide: BorderSide(
            color: Color.fromARGB(89, 181, 0, 0),
            width: 2,
          ),
        ),
        errorStyle: TextStyle(
          color: Color.fromARGB(255, 233, 1, 1),
          fontSize: 15,
          fontWeight: FontWeight(700),
        ),
        fillColor: safeAreaC,
        filled: true,
        labelText: "labelText",
        labelStyle: TextStyle(
          color: Color.fromARGB(105, 21, 21, 21),
          fontSize: 17,
          fontWeight: FontWeight(500),
        ),
      ),
      items: items,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
