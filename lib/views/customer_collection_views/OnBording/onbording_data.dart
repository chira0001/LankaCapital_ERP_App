import 'package:nkrs_app/models/onbording_model.dart';

class OnboardingData {
  static final List<OnboardingModel> onboarding_data_list = [
    OnboardingModel(
      title: "FIELD OFFICER OPTIMIZATION",
      imagePath: "assets/screen1.png",
      description:
          "Enable your field officers with digital tools. View routes, access customer details, record collection data, and manage schedules efficiently, all from their mobile device.",
    ),
    OnboardingModel(
      title: "CUSTOMER MANAGEMENT",
      imagePath: "assets/screen2.png",
      description:
          "Gain a central hub for all customer information. Easily view payment history, collection schedules, and outstanding balances to foster better customer relationships.",
    ),
    OnboardingModel(
      title: "SECURE DATA & INSIGHTS",
      imagePath: "assets/screen3.png",
      description:
          "Monitor business performance in real time. Track collection metrics, identify trends, and generate detailed reports for informed, data-driven decision-making.",
    ),
  ];
}
