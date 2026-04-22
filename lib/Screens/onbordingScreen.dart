import 'package:flutter/material.dart';
import 'package:nkrs_app/Data/onbording_data.dart';
import 'package:nkrs_app/Screens/OnBording/front_page.dart';
import 'package:nkrs_app/Screens/OnBording/shered_onbording.dart';
import 'package:nkrs_app/Screens/loginpage/login_page.dart';
import 'package:nkrs_app/constrants/colors.dart';
import 'package:nkrs_app/widgets/CusomButton.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onbordingscreen extends StatefulWidget {
  Onbordingscreen({super.key});

  @override
  State<Onbordingscreen> createState() => _OnbordingscreenState();
}

class _OnbordingscreenState extends State<Onbordingscreen> {
  final PageController pageController = PageController();
  bool showDetailsPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      showDetailsPage =
                          index == 3; // Show details page on the last page)
                    });
                  },
                  children: [
                    FrontPage(),
                    SheredOnbording(
                      title: OnbordingData.onbording_data_list[0].title,
                      imageParth:
                          OnbordingData.onbording_data_list[0].imageParth,
                      description:
                          OnbordingData.onbording_data_list[0].description,
                    ),

                    SheredOnbording(
                      title: OnbordingData.onbording_data_list[1].title,
                      imageParth:
                          OnbordingData.onbording_data_list[1].imageParth,
                      description:
                          OnbordingData.onbording_data_list[1].description,
                    ),

                    SheredOnbording(
                      title: OnbordingData.onbording_data_list[2].title,
                      imageParth:
                          OnbordingData.onbording_data_list[2].imageParth,
                      description:
                          OnbordingData.onbording_data_list[2].description,
                    ),
                  ],
                ),
                Container(
                  alignment: const Alignment(0, 0.7),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 4,
                    effect: WormEffect(
                      activeDotColor: Colors.blueAccent,
                      dotColor: Colors.grey.shade300,
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                  ),
                ),

                // navigation button
                Positioned(
                  bottom: 50,
                  right: 20,
                  left: 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),

                    child: GestureDetector(
                      onTap: () {
                        showDetailsPage
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              )
                            : pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                      },
                      child: CustomButton(
                        buttonName: showDetailsPage ? "Get Started" : "Next",
                        buttonColor: kMainColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
