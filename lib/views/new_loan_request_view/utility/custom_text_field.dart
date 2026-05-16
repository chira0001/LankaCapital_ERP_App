import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controllerNames;
  final String labelText_;
  final TextInputType? type;
  final String? Function(String?)? validatorCallback;
  final void Function(String?)? onSaveCallback;

  const CustomTextField({
    super.key,
    required this.controllerNames,
    required this.labelText_,
    this.type,
    this.validatorCallback,
    this.onSaveCallback,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerNames,
      keyboardType: type,
      autocorrect: false,
      cursorColor: const Color.fromARGB(255, 0, 55, 255),
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
            color: Color.fromARGB(58, 23, 23, 23),
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
        labelText: labelText_,
        labelStyle: TextStyle(
          color: Color.fromARGB(105, 21, 21, 21),
          fontSize: 17,
          fontWeight: FontWeight(500),
        ),
      ),
      validator: validatorCallback,
      onSaved: onSaveCallback,
    );
  }
}
