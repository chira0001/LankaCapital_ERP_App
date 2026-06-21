class InterestRateModel {
  // final int id;
  final double? rate;

  InterestRateModel({this.rate});

  factory InterestRateModel.fromJson(Map<String, dynamic> json) {
    return InterestRateModel(rate: json["rate"]);
  }

  factory InterestRateModel.fromMap(Map<String, dynamic> json) {
    return InterestRateModel(rate: (json["rate"] as double));
  }
}
