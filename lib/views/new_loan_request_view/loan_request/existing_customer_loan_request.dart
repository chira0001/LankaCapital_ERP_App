// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/data/view_model/add_loan_view.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/models/Interest_rate_model.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/installments_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_drop_down.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_text_field.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/navigator_back.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/popup_box_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/successfull_message_view.dart';

class ExistingCustomerLoanRequest extends StatefulWidget {
  final int nicNumber;
  final List<InstallmentsModel> installments;
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
  final TextEditingController nic = TextEditingController();
  final double _customSize_1 = 4;
  final double _customSize_2 = 25;

  // double amount = 0.0;
  // double interestRates = 0.0;
  // int noOfInstallments = 0;
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarC,
        elevation: 2.0,
        shadowColor: appBarShadow,
        leading: IconButton(
          onPressed: () {
            NavigatorBack.customPopUpBox(
              context,
              destination: LoanRequestSection(),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        title: Text("Existing Customer Loan"),
        titleTextStyle: TextStyle(
          color: btnC,
          fontSize: appBarFontS,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: ValueListenableBuilder<bool>(
              valueListenable: CheckConnection.isOnline,
              builder: (context, online, child) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      CheckConnection.initialize();
                    });
                    showTopNotification(
                      context,
                      online ? "Device is Online" : "Device is Offline",
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: online
                          ? const Color.fromARGB(40, 9, 172, 58)
                          : const Color.fromARGB(40, 172, 9, 9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: online
                            ? const Color.fromARGB(255, 9, 172, 58)
                            : const Color.fromARGB(255, 172, 9, 9),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      online ? "ONLINE" : "OFFLINE",
                      style: TextStyle(
                        color: online
                            ? const Color.fromARGB(255, 9, 172, 58)
                            : const Color.fromARGB(255, 172, 9, 9),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
                          if (value == null || value.isEmpty) {
                            return "Please enter the loan amount";
                          } else if (value as double == 0) {
                            return "Please enter a valid loan amount";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: _customSize_2),
                      customText("Loan Type"),
                      SizedBox(height: _customSize_1),
                      CustomDropDown<int>(
                        hint: "-- --",
                        btnBorderRadius: btnBorderRadius,
                        safeAreaC: safeAreaC,
                        items: widget.installments.map((item) {
                          return DropdownMenuItem<int>(
                            value: item.id.toInt(),
                            child: Text(item.value.toString()),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return "Please select Loan type";
                          }
                          return null;
                        },
                        onChanged: (int? newValue) {
                          print(newValue);
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
                            value: item.id.toInt(),

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
                          InstallmentsModel selectedItem = widget.installments
                              .firstWhere((item) => item.id == newValue!);
                          print(selectedItem.id);
                          print(selectedItem.value);
                        },
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: (state)
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () async {
                                  print("star1");
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    print("star2");

                                    setState(() {
                                      state = true;
                                    });
                                    final AddLoanView addLoanView =
                                        AddLoanView();
                                    bool success = await addLoanView
                                        .addLoanByOnline(
                                          AddLoanModel(
                                            amount: double.parse(
                                              loanAmount.text.trim(),
                                            ),
                                            // customerNic: widget.nicNumber,
                                            customerNic: 200227800587,
                                            employeeId: 1,
                                            installmentId: 1,
                                          ),
                                          context,
                                        );
                                    setState(() {
                                      state = false;
                                    });
                                    if (success) {
                                      Navigator.push(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoanSuccessScreen(),
                                        ),
                                      );
                                    }
                                  }
                                  setState(() {
                                    state = false;
                                  });
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
                                child:
                                    //  (state)
                                    //     ? Container(
                                    //         width: 28,
                                    //         height: 28,
                                    //         padding: const EdgeInsets.all(4),
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.white.withOpacity(0.15),
                                    //           shape: BoxShape.circle,
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.black.withOpacity(
                                    //                 0.15,
                                    //               ),
                                    //               blurRadius: 8,
                                    //               offset: const Offset(0, 3),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: const CircularProgressIndicator(
                                    //           strokeWidth: 3,
                                    //           valueColor:
                                    //               AlwaysStoppedAnimation<Color>(
                                    //                 Colors.white,
                                    //               ),
                                    //         ),
                                    //       )
                                    //     :
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
