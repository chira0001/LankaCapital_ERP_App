class InterestRateModel {
  // final int id;
  final double? rate;

  InterestRateModel({
    // required this.id,
    this.rate,
  });

  factory InterestRateModel.fromJson(Map<String, dynamic> json) {
    return InterestRateModel(
      // id: json["id"],
      rate: json["rate"],
    );
  }

  factory InterestRateModel.fromMap(Map<String, dynamic> json) {
    return InterestRateModel(
      // id: json["id"],
      rate: (json["rate"] as double),
    );
  }
}
