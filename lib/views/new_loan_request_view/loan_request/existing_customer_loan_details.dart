import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';

// ignore: must_be_immutable
class LoanDetailsPage extends StatelessWidget {
  String? fileNumber = "nkfs";
  double amount = 10000.0;
  String? createdAt = "20026/56/5";
  double interestRate = 10.5;
  int noOfInstallments = 5;
  double documentCharge = 100;
  int? employeeId = 12;
  String? employeeName = "Chirath wijesinghan";

  LoanDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: safeAreaC,
      appBar: AppBar(
        backgroundColor: appBarC,
        elevation: 2.0,
        shadowColor: appBarShadow,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color.fromARGB(185, 0, 0, 0),
            size: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        title: Text("Customer Loan Details"),
        titleTextStyle: TextStyle(
          color: btnC,
          fontSize: appBarFontS,
          fontWeight: FontWeight.bold,
        ),
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
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    'LOAN SPECIFICATIONS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 149, 149, 149),
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Container(
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
                        '${interestRate.toStringAsFixed(2)}%',
                      ),
                      const Divider(height: 24, thickness: 0.8),
                      _buildDetailRow(
                        'Installments',
                        '$noOfInstallments Months',
                      ),
                      const Divider(height: 24, thickness: 0.8),
                      _buildDetailRow(
                        'Document Charge',
                        'Rs. ${documentCharge.toStringAsFixed(2)}',
                      ),
                      const Divider(height: 24, thickness: 0.8),
                      _buildDetailRow('Created Date', createdAt ?? 'N/A'),
                    ],
                  ),
                ),
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
                  employeeName ?? 'No Officer Assigned',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3D81),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employeeId != null ? 'Officer ID: #$employeeId' : 'ID: N/A',
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

  // Highlight Card (Top Area)
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
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            fileNumber!,
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
            'Rs. ${amount.toStringAsFixed(2)}',
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
