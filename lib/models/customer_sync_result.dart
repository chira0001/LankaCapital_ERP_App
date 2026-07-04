import 'package:nkrs_app/models/sync_loan_resp_model.dart';

class CustomerSyncResult {
  final bool success;
  final List<int>? successId;
  final List<int>? failedId;
  final List<SyncLoanRespModel>? obj;

  CustomerSyncResult({
    required this.success,
    this.successId = const [],
    this.failedId = const [],
    this.obj = const [],
  });
}
