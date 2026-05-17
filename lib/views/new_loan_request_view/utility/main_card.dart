import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/utility/constanst.dart';

class MainCard extends StatelessWidget {
  final String header;
  final String description;
  final IconData cusIconRight;
  final Color iconColor;
  final Color iconBackgrouundColor;

  const MainCard({
    super.key,
    required this.header,
    required this.description,
    required this.cusIconRight,
    required this.iconColor,
    required this.iconBackgrouundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(innerBoxPD),
      decoration: BoxDecoration(
        color: appBarC,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: boxShadowC.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
        border: BoxBorder.all(color: boaderC, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBackgrouundColor,
                  border: Border.all(
                    color: const Color.fromARGB(19, 0, 16, 99),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(cardBorderRadius - 5),
                ),
                child: Icon(
                  cusIconRight,
                  size: 25,
                  color: iconColor,
                  fontWeight: FontWeight(900),
                ),
              ),
              Icon(
                Iconsax.arrow_right_3_copy,
                size: 20,
                color: const Color.fromARGB(119, 21, 21, 21),
                fontWeight: FontWeight(700),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            header,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight(HeaderFW),
              fontSize: cardHeaderFS,
              color: cardHeaderFC,
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: cardDescriptionFS,
              fontWeight: FontWeight(cardDescriptionFW),
              color: cardDescriptionFC,
            ),
          ),
        ],
      ),
    );
  }

  static BoxShadow customShadow() {
    return BoxShadow(
      color: boxShadowC,
      blurRadius: 10,
      offset: const Offset(0, 5),
    );
  }
}

class CutsomTextBox {
  Widget customBuild(
    final TextEditingController controllerNames,
    final String labelText_,
    final TextInputType? type,
    final String? Function(String?)? validatorCallback,
  ) {
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
    );
  }
}
