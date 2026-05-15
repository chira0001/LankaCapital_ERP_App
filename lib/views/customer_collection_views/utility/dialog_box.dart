import 'package:flutter/material.dart';
import 'package:nkrs_app/models/loan_model.dart';

class DialogBox {
  final List<Loan> loans;
  final TextEditingController nicController;
  final TextEditingController lorncontroller;
  final Function(Loan)? onLoanSelected;

  DialogBox({
    required this.loans,
    required this.nicController,
    required this.lorncontroller,
    this.onLoanSelected,
  });

  void showLoanDialog(BuildContext context) {
    String? selectedFileNumber;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Loan"),
              content: DropdownButton<String>(
                isExpanded: true,
                value: selectedFileNumber,
                hint: const Text("Select a Loan File"),
                items: loans.map((loan) {
                  return DropdownMenuItem<String>(
                    value: loan.fileNumber,
                    child: Text(
                      '${loan.fileNumber}  •  ${loan.amount.toStringAsFixed(2)} LKR  •  ${loan.interestRate}%',
                    ),
                  );
                }).toList(),
                onChanged: (fileNumber) {
                  setState(() {
                    selectedFileNumber = fileNumber;
                  });

                  final selectedLoan = loans.firstWhere(
                    (loan) => loan.fileNumber == fileNumber,
                  );

                  // Fill loan number field with the file number (e.g. D001)
                  lorncontroller.text = selectedLoan.fileNumber;
                  // NICcontroller already has the NIC — keep it as-is

                  if (onLoanSelected != null) {
                    onLoanSelected!(selectedLoan);
                  }

                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }
}