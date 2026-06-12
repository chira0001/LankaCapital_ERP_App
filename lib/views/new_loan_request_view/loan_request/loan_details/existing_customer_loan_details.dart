import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nkrs_app/models/user_loan_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_app_bar.dart';

class LoanDetailsPage extends StatelessWidget {
  final UserLoanModel loan;
  const LoanDetailsPage({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: safeAreaC,
      appBar: CustomAppBar(
        title: "Customer Loan Details",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: safeAreaHorizontalPD,
              vertical: safeAreaVerticalPD,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainCard(),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    'ASSIGNED FIELD OFFICER',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 149, 149, 149),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                _buildOfficerCard(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    (loan.status.toLowerCase() == "rejected")
                        ? 'LOAN REJECTED NOTE'
                        : 'LOAN SPECIFICATIONS',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 149, 149, 149),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                (loan.status.toLowerCase() == "rejected")
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "data",
                          style: TextStyle(
                            color: Color(0xFF1A3D81),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              'Interest Rate',
                              (loan.interestRate?.rate != null &&
                                      loan.interestRate!.rate != 0.0)
                                  ? '${loan.interestRate?.rate!.toStringAsFixed(2)}%'
                                  : "Pending",
                            ),
                            const Divider(height: 24, thickness: 0.8),
                            _buildDetailRow(
                              'Installments',
                              '${loan.installments.value}',
                            ),
                            const Divider(height: 24, thickness: 0.8),
                            _buildDetailRow(
                              'Document Charge',
                              (loan.documentCharge ?? 0.0) > 0
                                  ? 'Rs. ${loan.documentCharge!.toStringAsFixed(2)}'
                                  : 'Pending',
                            ),
                            const Divider(height: 24, thickness: 0.8),
                            _buildDetailRow(
                              'Created Date',
                              DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(
                                  loan.createdAt.replaceFirst(' ', 'T'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    'LOAN STATUS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 149, 149, 149),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                loan.status.toLowerCase() == "pending"
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          "Your loan application is under review. Thank you for your patience.",
                          style: TextStyle(
                            color: Color(0xFF1A3D81),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfficerCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ignore: deprecated_member_use
          color: const Color(0xFF1A3D81).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Circular Badge for Officer Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: const Color(0xFF1A3D81).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: Color(0xFF1A3D81),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Officer ID & Name details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${loan.employee.firstName} ${loan.employee.lastName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3D81),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contact No: ${loan.employee.phoneNumber}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3D81), Color(0xFF2E5CB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color(0xFF1A3D81).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'FILE NUMBER',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: const Color.fromARGB(31, 255, 238, 225),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  loan.status,
                  style: TextStyle(
                    color: switch (loan.status) {
                      'APPROVED' => Colors.green[700],
                      'PENDING' => Colors.amber[600],
                      'REJECTED' => Colors.red[700],
                      _ => Colors.grey[600],
                    },
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            loan.fileNumber!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'LOAN AMOUNT',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rs. ${loan.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Color(0xFF1A3D81),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
