import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/utility/constanst.dart';

class NavigatorBack {
  static void customPopUpBox(
    BuildContext context, {
    required Widget destination,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.37,
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Iconsax.warning_2_copy,
                  color: const Color.fromARGB(164, 175, 6, 6),
                  size: 43,
                  fontWeight: FontWeight(700),
                  shadows: [
                    Shadow(
                      blurRadius: 60,
                      color: const Color.fromARGB(255, 252, 0, 0),
                    ),
                  ],
                ),
                Text(
                  "Are you sure?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight(HeaderFW),
                  ),
                ),
                Text(
                  "You have unsaved changes. If you leave now, your progress will be lost.",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight(descriptionFw),
                    // ignore: deprecated_member_use
                    color: descriptionC.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.39,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => destination,
                            ),
                            (route) => false,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: btnC,
                            borderRadius: BorderRadius.circular(
                              btnBorderRadius,
                            ),
                          ),
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: 10,
                          ),
                          child: Text(
                            "HOME",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: btnFontSize,
                              fontWeight: FontWeight(HeaderFW),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.39,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: appBarC,
                            borderRadius: BorderRadius.circular(
                              btnBorderRadius,
                            ),
                            border: Border.all(color: btnC, width: 2),
                          ),
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: 10,
                          ),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: btnFontSize,
                              fontWeight: FontWeight(HeaderFW),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.transparent),
              ],
            ),
          ),
        );
      },
    );
  }
}
