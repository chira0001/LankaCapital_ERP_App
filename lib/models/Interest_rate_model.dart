class InterestRateModel {
  // final int id;
  final double rate;

  InterestRateModel({
    // required this.id,
    required this.rate,
  });

  factory InterestRateModel.fromMap(Map<String, dynamic> json) {
    return InterestRateModel(
      // id: json["id"],
      rate: json["rate"] as double,
    );
  }
}
