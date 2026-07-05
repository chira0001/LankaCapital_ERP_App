import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nkrs_app/models/installment_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_drop_down.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_text_field.dart';

class LoanRequestSectionView extends StatelessWidget {
  final List<InstallmentModel> installments;
  final TextEditingController _loanAmount;
  final TextEditingController _installment;
  const LoanRequestSectionView({
    super.key,
    required this.installments,
    required TextEditingController loanAmount,
    required TextEditingController installment,
  }) : _installment = installment,
       _loanAmount = loanAmount;

  static final double _customSize_1 = 4;
  static final double _customSize_2 = 25;

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
                "Loan Details",
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
          customText("Loan Amount"),
          SizedBox(height: _customSize_1),
          CustomTextField(
            controllerNames: _loanAmount,
            labelText_: "XXXXX.XX",
            type: TextInputType.number,
            validatorCallback: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the loan amount";
              } else if (double.parse(value) < 10000 ||
                  double.parse(value) > 500000) {
                return "Please enter a valid loan amount";
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: _customSize_2),
          customText("Loan Type"),
          SizedBox(height: _customSize_1),
          CustomDropDown<String>(
            hint: "-- --",
            btnBorderRadius: btnBorderRadius,
            safeAreaC: safeAreaC,
            items: const [
              DropdownMenuItem<String>(value: "day", child: Text("Day")),
              DropdownMenuItem<String>(value: "week", child: Text("Week")),
            ],
            validator: (value) {
              if (value == null) {
                return "Please select Loan type";
              }
              return null;
            },
            onChanged: (String? newValue) {
              print(newValue);
            },
          ),
          SizedBox(height: _customSize_2),
          customText("Installment"),
          SizedBox(height: _customSize_1),
          CustomDropDown<int>(
            hint: "Loan Duration",
            btnBorderRadius: btnBorderRadius,
            safeAreaC: safeAreaC,
            items: installments.map((item) {
              return DropdownMenuItem<int>(
                value: item.id?.toInt(),
                child: Text(item.value.toString()),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return "Please select duration";
              }
              return null;
            },
            onChanged: (int? newValue) {
              InstallmentModel selectedItem = installments.firstWhere(
                (item) => item.id == newValue!.toDouble(),
              );
              _installment.text = selectedItem.id.toString();
              print(_installment.text);
              // print(selectedItem.value);
            },
          ),
        ],
      ),
    );
  }

  Text customText(String lable_) {
    return Text(
      lable_.toUpperCase(),
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(138, 26, 26, 26),
      ),
    );
  }
}
