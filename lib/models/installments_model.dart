class InstallmentsModel {

  final double id;
  final int value;

  InstallmentsModel({
    required this.id,
    required this.value,
  });

  factory InstallmentsModel.fromJson(
      Map<String, dynamic> json,
  ) {

    return InstallmentsModel(
      id: json["id"].toDouble(),
      value: json["value"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "value": value,
    };
  }
}