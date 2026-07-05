class InterestRateUpdate {
  final int id;
  final int rate;
  final int status;

  InterestRateUpdate({
    required this.id,
    required this.rate,
    required this.status,
  });

  factory InterestRateUpdate.fromServer(Map<String, dynamic> json) {
    return InterestRateUpdate(
      id: json['id'] as int,
      rate: json['rate'] as int,
      status: json['status'] as int
    );
  }

  factory InterestRateUpdate.fromDatabase(Map<String, dynamic> json) {
    return InterestRateUpdate(
      id: json['id'] as int,
      rate: json['rate'] as int,
      status: json['update_status'] as int
    );
  }
}