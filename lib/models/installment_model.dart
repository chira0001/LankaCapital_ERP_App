class InstallmentModel {
  final int? id;
  final int value;

  InstallmentModel({this.id, required this.value});

  factory InstallmentModel.fromMap(Map<String, dynamic> map) {
    return InstallmentModel(value: map['value'] as int);
  }

  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(id: json["id"] as int, value: json["value"]);
  }
}
