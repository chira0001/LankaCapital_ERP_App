import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/navigator_back.dart';

class ExistingCustomerLoanRequest extends StatefulWidget {
  final int nicNumber;
  const ExistingCustomerLoanRequest({super.key, required this.nicNumber});

  @override
  State<ExistingCustomerLoanRequest> createState() =>
      _ExistingCustomerLoanRequestState();
}

class _ExistingCustomerLoanRequestState
    extends State<ExistingCustomerLoanRequest> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController loanAmount = TextEditingController();
  final TextEditingController interestRate = TextEditingController();
  final TextEditingController installment = TextEditingController();
  final TextEditingController nic = TextEditingController();
  final double _customSize_1 = 10;
  final double _customSize_2 = 25;

  // loan variable
  double amount = 0.0;
  double interestRates = 0.0;
  // int customerId = 0; //customer NIC
  // int employeeId = 0;
  int noOfInstallments = 0;

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
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.help_outline,
                color: const Color.fromARGB(118, 17, 17, 17),
                size: 26,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: safeAreaC,
      body: SingleChildScrollView(
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
                    _customBuild(
                      loanAmount,
                      "XXXXX.XX",
                      TextInputType.number,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the loan amount";
                        } else if (value as double == 0) {
                          return "Please enter a valid loan amount";
                        } else {
                          return null;
                        }
                      },
                      (value) {
                        amount = value as double;
                      },
                    ),
                    SizedBox(height: _customSize_2),
                    customText("Interest Rate"),
                    SizedBox(height: _customSize_1),
                    _customBuild(
                      interestRate,
                      "XX.XX%",
                      TextInputType.number,
                      (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the interest rate";
                        } else if (value as int < 0) {
                          return "Please enter a valid interest rate";
                        } else if (value as int < 0 || value as int >= 100) {
                          return "Please enter an interest rate between 0 and 100";
                        } else {
                          return null;
                        }
                      },
                      (value) {
                        interestRates = value as double;
                      },
                    ),
                    SizedBox(height: _customSize_2),
                    customText("Loan Duration"),
                    SizedBox(height: _customSize_1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: _customBuild(
                            installment,
                            "No of Installments",
                            TextInputType.number,
                            (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the number of installments";
                              } else if (value as int < 0) {
                                return "Please enter a valid number of installments";
                              } else {
                                return null;
                              }
                            },
                            (value) {
                              noOfInstallments = value as int;
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: DropdownButtonFormField<String>(
                            hint: Text("Choose"),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF1A3D81),
                            ),
                            decoration: InputDecoration(
                              floatingLabelStyle: TextStyle(fontSize: 1),
                              errorMaxLines: 2,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(btnBorderRadius),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(btnBorderRadius),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(58, 23, 23, 23),
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(btnBorderRadius),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(89, 181, 0, 0),
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                color: Color.fromARGB(255, 233, 1, 1),
                                fontSize: 15,
                                fontWeight: FontWeight(700),
                              ),
                              fillColor: safeAreaC,
                              filled: true,
                              labelText: "labelText",
                              labelStyle: TextStyle(
                                color: Color.fromARGB(105, 21, 21, 21),
                                fontSize: 17,
                                fontWeight: FontWeight(500),
                              ),
                            ),
                            items: ["Days", "Weeks"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Color(0xFF1A3D81)),
                                ),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select a duration type";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (newValue) {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          AddLoanModel addLoanModel = AddLoanModel(
                            amount: amount,
                            customerId: 12,
                            employeeId: 1,
                            interestRate: interestRates,
                            noOfInstallments: noOfInstallments
                          );
                        }
                        // Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LoanSuccessScreen(),
                        //   ),
                        // );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: btnC,
                          borderRadius: BorderRadius.circular(btnBorderRadius),
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
                            SizedBox(width: 10),
                            Icon(
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
    );
  }

  Widget _customBuild(
    final TextEditingController controllerNames,
    final String labelText_,
    final TextInputType? type,
    final String? Function(String?)? validatorCallback,
    final String? Function(String?)? onSaveCallback,
  ) {
    return TextFormField(
      controller: controllerNames,
      keyboardType: type,
      autocorrect: false,
      cursorColor: const Color.fromARGB(255, 0, 55, 255),
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(fontSize: 1),
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
          borderSide: BorderSide(
            color: Color.fromARGB(58, 23, 23, 23),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnBorderRadius)),
          borderSide: BorderSide(
            color: Color.fromARGB(89, 181, 0, 0),
            width: 2,
          ),
        ),
        errorStyle: TextStyle(
          color: Color.fromARGB(255, 233, 1, 1),
          fontSize: 15,
          fontWeight: FontWeight(700),
        ),
        fillColor: safeAreaC,
        filled: true,
        labelText: labelText_,
        labelStyle: TextStyle(
          color: Color.fromARGB(105, 21, 21, 21),
          fontSize: 17,
          fontWeight: FontWeight(500),
        ),
      ),
      validator: validatorCallback,
      onSaved: onSaveCallback,
    );
  }

  Text customText(String lable_) {
    return Text(
      lable_,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight(800),
        color: const Color.fromARGB(156, 26, 26, 26),
      ),
    );
  }
}
