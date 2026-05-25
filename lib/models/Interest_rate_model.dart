class InterestRateModel {
  final int id;
  final double rate;

  InterestRateModel({
    required this.id,
    required this.rate,
  });

  factory InterestRateModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return InterestRateModel(
      id: json["id"],
      rate: json["rate"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "rate": rate,
    };
  }
}