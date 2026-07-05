import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/colors.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/front_page.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/onbording_data.dart';
import 'package:nkrs_app/views/customer_collection_views/OnBording/shered_onbording.dart';
import 'package:nkrs_app/views/customer_collection_views/loginpage/login_page.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onbordingscreen extends StatefulWidget {
  const Onbordingscreen({super.key});

  @override
  State<Onbordingscreen> createState() => _OnbordingscreenState();
}

class _OnbordingscreenState extends State<Onbordingscreen> {
  final PageController pageController = PageController();
  bool showDetailsPage = false;

  /// Writes the 'onboarding_seen' flag then navigates to [LoginPage].
  /// Called only when the user taps "Get Started" on the last page.
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);

    if (!mounted) return;

    // pushReplacement so the back button cannot return to onboarding.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

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
                      showDetailsPage = index == 3;
                    });
                  },
                  children: [
                    FrontPage(),
                    SheredOnbording(
                      title: OnboardingData.onboardingDataList[0].title,
                      imageParth: OnboardingData.onboardingDataList[0].imagePath,
                      description: OnboardingData.onboardingDataList[0].description,
                    ),
                    SheredOnbording(
                      title: OnboardingData.onboardingDataList[1].title,
                      imageParth: OnboardingData.onboardingDataList[1].imagePath,
                      description: OnboardingData.onboardingDataList[1].description,
                    ),
                    SheredOnbording(
                      title: OnboardingData.onboardingDataList[2].title,
                      imageParth: OnboardingData.onboardingDataList[2].imagePath,
                      description: OnboardingData.onboardingDataList[2].description,
                    ),
                  ],
                ),

                // Dot indicator
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

                // Next / Get Started button
                Positioned(
                  bottom: 50,
                  right: 20,
                  left: 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: GestureDetector(
                      onTap: () {
                        if (showDetailsPage) {
                          // Last page — mark onboarding done & go to login
                          _completeOnboarding();
                        } else {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
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
