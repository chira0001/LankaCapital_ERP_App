class CustomerSyncResult {
  final bool success;
  final List<int>? successId;
  final List<int>? failedId;
  final String? message;

  CustomerSyncResult({
    required this.success,
    this.message,
    this.successId = const [],
    this.failedId = const [],
  });
}
