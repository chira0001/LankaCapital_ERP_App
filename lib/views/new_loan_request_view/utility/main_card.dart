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
        color: safeAreaC,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: boxShadowC.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: BoxBorder.all(color: boaderC, width: 1),
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
