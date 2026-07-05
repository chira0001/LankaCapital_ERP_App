import 'dart:core';
import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_row.dart';

class SummaryStep extends StatelessWidget {
  final String name;
  final String nic;
  final String phoneNumber;
  final String email;
  final String address;
  final String amount;
  final String type;
  final String installment;
  const SummaryStep({
    super.key,
    required this.name,
    required this.nic,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.amount,
    required this.type,
    required this.installment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Customer Details",
                style: TextStyle(
                  fontSize: cardHeaderFS,
                  color: cardHeaderFC,
                  fontWeight: FontWeight(700),
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.info_outline_rounded,
                  size: 25,
                  color: const Color.fromARGB(94, 51, 51, 51),
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRow(label: "Full Name", value: name),
                CustomRow(label: "NIC Number", value: nic),
                CustomRow(label: "Phone", value: phoneNumber),
                CustomRow(label: "Email", value: email),
                CustomRow(label: "Address", value: address),
              ],
            ),
          ),
          SizedBox(height: 40),
          Text(
            "Loan Details",
            style: TextStyle(
              fontSize: cardHeaderFS,
              color: cardHeaderFC,
              fontWeight: FontWeight(700),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRow(label: "Loan Type", value: "$type Loan"),
                CustomRow(label: "No Installment", value: installment),
                SizedBox(height: 15),
                Divider(
                  color: const Color.fromARGB(44, 33, 33, 33),
                  thickness: 1.5,
                ),
                _buildLoanRow("Amount", amount, isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color.fromARGB(216, 97, 97, 97),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF1A3D81),
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
