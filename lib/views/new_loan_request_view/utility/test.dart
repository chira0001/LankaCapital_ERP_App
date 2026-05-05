import 'package:flutter/material.dart';

class ExistingCustomerLoans extends StatefulWidget {
  const ExistingCustomerLoans({super.key});

  @override
  State<ExistingCustomerLoans> createState() => _ExistingCustomerLoansState();
}

class _ExistingCustomerLoansState extends State<ExistingCustomerLoans> {
  // Controller for the NIC Search field
  final TextEditingController nicSearchController = TextEditingController();

  // State variable to toggle visibility of results
  bool showDetails = false;

  // Mock data representing multiple loans for one user
  final List<Map<String, String>> userLoans = [
    {
      "id": "L-9920",
      "amount": "LKR 250,000.00",
      "date": "2026-02-15",
      "status": "Active",
    },
    {
      "id": "L-8841",
      "amount": "LKR 75,000.00",
      "date": "2025-11-10",
      "status": "Paid",
    },
    {
      "id": "L-7712",
      "amount": "LKR 120,000.00",
      "date": "2025-05-20",
      "status": "Closed",
    },
  ];

  @override
  void dispose() {
    nicSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: const Icon(Icons.arrow_back, color: Colors.black),
          title: const Text(
            "Existing Customer Loan",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.help_outline, color: Colors.grey),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Existing Customer Loan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3D81),
                ),
              ),
              const Text(
                "Loan Management for Existing Customers",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 25),

              // --- CUSTOMER VERIFICATION SECTION ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "CUSTOMER VERIFICATION",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: nicSearchController,
                            decoration: InputDecoration(
                              hintText: "Enter Customer ID",
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: const Color(0xFFF3F4F6),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showDetails = true; // Displays the ListView below
                            });
                          },
                          child: const Text(
                            "FIND",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- LOAN LIST VIEW SECTION ---
              if (showDetails) ...[
                const Text(
                  "Active & Past Loans",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3D81),
                  ),
                ),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userLoans.length,
                  itemBuilder: (context, index) {
                    final loan = userLoans[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.1)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(
                            0xFF1A3D81,
                          ).withOpacity(0.1),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFF1A3D81),
                          ),
                        ),
                        title: Text(
                          "Loan ID: ${loan['id']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A3D81),
                          ),
                        ),
                        subtitle: Text("Issued: ${loan['date']}"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              loan['amount']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: loan['status'] == "Active"
                                    ? Colors.green[50]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                loan['status']!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: loan['status'] == "Active"
                                      ? Colors.green[700]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigate to specific loan details
                        },
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
