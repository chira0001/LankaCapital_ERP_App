import 'package:nkrs_app/models/onbording_model.dart';

class OnbordingData {
  static final List<OnbordingModel> onbording_data_list = [
    OnbordingModel(
      title: "FIELD OFFICER OPTIMIZATION",
      imageParth: "Assets/screen1.png",
      description:
          "Enable your field officers with digital tools. View routes, access customer details, record collection data, and manage schedules efficiently, all from their mobile device.",
    ),
    OnbordingModel(
      title: "CUSTOMER MANAGEMENT",
      imageParth: "Assets/screen2.png",
      description:
          "Gain a central hub for all customer information. Easily view payment history, collection schedules, and outstanding balances to foster better customer relationships.",
    ),
    OnbordingModel(
      title: "SECURE DATA & INSIGHTS",
      imageParth: "Assets/screen3.png",
      description:
          "Monitor business performance in real time. Track collection metrics, identify trends, and generate detailed reports for informed, data-driven decision-making.",
    ),
  ];
}
