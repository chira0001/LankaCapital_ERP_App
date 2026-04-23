import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/colors.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/cusomButton.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/front_page.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/onbording_data.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/shered_onbording.dart';
import 'package:nkrs_app/views/customer_collection_views/loginpage/login_page.dart';
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
                      title: OnboardingData.onboarding_data_list[0].title,
                      imageParth:
                          OnboardingData.onboarding_data_list[0].imagePath,
                      description:
                          OnboardingData.onboarding_data_list[0].description,
                    ),

                    SheredOnbording(
                      title: OnboardingData.onboarding_data_list[1].title,
                      imageParth:
                          OnboardingData.onboarding_data_list[1].imagePath,
                      description:
                          OnboardingData.onboarding_data_list[1].description,
                    ),

                    SheredOnbording(
                      title: OnboardingData.onboarding_data_list[2].title,
                      imageParth:
                          OnboardingData.onboarding_data_list[2].imagePath,
                      description:
                          OnboardingData.onboarding_data_list[2].description,
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
