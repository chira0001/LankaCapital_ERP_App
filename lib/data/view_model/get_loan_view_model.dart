// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/installments_model.dart';

class GetLoanViewModel {
  final LoanService _service = LoanService();

  Future<List<InstallmentsModel>?> getLoanDataByOnline(
    BuildContext context,
  ) async {
    List<InstallmentsModel>? installments = await _service.getInstallments();

    if (installments != null) {
      if (installments.isNotEmpty) {
        return installments;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No installment data found")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Server connection failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  Future<void> getLoanDataByOffline(BuildContext context) async {}
}
