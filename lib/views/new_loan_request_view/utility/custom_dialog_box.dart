import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';

class CustomDialogBox extends StatelessWidget {
  final VoidCallback rightBtn;
  final VoidCallback leftBtn;
  final String imageURL;
  final String header;
  final String description;
  final Color imageBColor;

  const CustomDialogBox({
    super.key,
    required this.imageURL,
    required this.header,
    required this.description,
    required this.imageBColor,
    required this.rightBtn,
    required this.leftBtn,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 500,
        padding: const EdgeInsets.only(
          left: 20,
          top: 50,
          right: 20,
          bottom: 20,
        ),
        // margin: const EdgeInsets.only(top: 45),
        decoration: BoxDecoration(
          // shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.check_circle,
            //   // Iconsax.tick_circle,
            //   color: const Color.fromARGB(255, 0, 102, 255),
            //   size: 70,
            //   shadows: [
            //     Shadow(
            //       color: const Color.fromARGB(255, 0, 255, 8).withOpacity(0.9),
            //       blurRadius: 50,
            //     ),
            //   ],
            // ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: imageBColor,
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  imageURL,
                  // 'assets/images/success-icon.png',
                  height: 70,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              header,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            // SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color.fromARGB(174, 35, 35, 35),
              ),
            ),
            SizedBox(height: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      leftBtn();
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnC,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(btnBorderRadius),
                        ),
                      ),
                      child: Text(
                        "Home",
                        style: TextStyle(
                          letterSpacing: 1,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: btnFontSize,
                          fontWeight: FontWeight(700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        rightBtn();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(btnBorderRadius),
                          side: BorderSide(
                            color: Color.fromARGB(138, 175, 175, 175),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        "View Status",
                        style: TextStyle(
                          letterSpacing: 1,
                          color: btnC,
                          fontSize: btnFontSize,
                          fontWeight: FontWeight(700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            // StreamBuilder(stream: stream, builder: builder)
          ],
        ),
      ),
    );
  }
}
