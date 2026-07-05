// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/data/view_model/loan_view_model.dart';
import 'package:nkrs_app/models/interest_rate_model.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/installment_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_app_bar.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_drop_down.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_text_field.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/loading_dialog.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/successfull_message_view.dart';

class ExistingCustomerLoanRequest extends StatefulWidget {
  final int nicNumber;
  final List<InstallmentModel> installments;
  final List<InterestRateModel>? interestRates;
  const ExistingCustomerLoanRequest({
    super.key,
    required this.nicNumber,
    required this.installments,
    this.interestRates,
  });

  @override
  State<ExistingCustomerLoanRequest> createState() =>
      _ExistingCustomerLoanRequestState();
}

class _ExistingCustomerLoanRequestState
    extends State<ExistingCustomerLoanRequest> {
  @override
  void initState() {
    super.initState();
    CheckConnection.initialize();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController loanAmount = TextEditingController();
  final TextEditingController interestRate = TextEditingController();
  final TextEditingController installment = TextEditingController();
  final double _customSize_1 = 4;
  final double _customSize_2 = 25;

  @override
  Widget build(BuildContext context) {
    late int id;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Existing Customer Loan",
        onBackPressed: () => Navigator.pop(context),
      ),
      backgroundColor: safeAreaC,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: safeAreaHorizontalPD,
                vertical: safeAreaVerticalPD,
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: appBarC,
                  borderRadius: BorderRadius.all(
                    Radius.circular(cardBorderRadius),
                  ),
                  boxShadow: [MainCard.customShadow()],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Iconsax.user,
                            size: 25,
                            color: Color.fromARGB(255, 126, 146, 185),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Loan Details",
                            style: TextStyle(
                              fontSize: cardHeaderFS,
                              color: cardHeaderFC,
                              fontWeight: FontWeight(700),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      customText("Loan Amount"),
                      SizedBox(height: _customSize_1),
                      CustomTextField(
                        controllerNames: loanAmount,
                        labelText_: "XXXXX.XX",
                        type: TextInputType.number,
                        validatorCallback: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter the loan amount";
                          }
                          final amount = double.tryParse(value.trim());
                          if (amount == null) {
                            return "Please enter a valid number";
                          }
                          if (amount <= 0) {
                            return "Loan amount must be greater than 0";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: _customSize_2),
                      customText("Interest Rate"),
                      SizedBox(height: _customSize_1),
                      CustomDropDown<int>(
                        hint: "Loan Duration",
                        btnBorderRadius: btnBorderRadius,
                        safeAreaC: safeAreaC,
                        items: widget.installments.map((item) {
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
                          InstallmentModel selectedItem = widget.installments
                              .firstWhere((item) => item.id == newValue!);
                          id = selectedItem.id as int;
                        },
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              LoadingDialog.show(
                                context,
                                message: 'Please Wait...',
                              );
                              final bool success = await LoanViewModel()
                                  .existingLoan(
                                    AddLoanModel(
                                      amount: double.parse(
                                        loanAmount.text.trim(),
                                      ),
                                      customerNic: widget.nicNumber,
                                      employeeId: 1,
                                      installmentId: id,
                                    ),
                                    context,
                                  );
                              if (!context.mounted) return;
                              LoadingDialog.hide(context);
                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoanSuccessScreen(
                                      bottomNavigatorBackButton: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoanRequestSection(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnC,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                btnBorderRadius,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Apply for Loan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: btnFontSize,
                                  fontWeight: FontWeight(700),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
