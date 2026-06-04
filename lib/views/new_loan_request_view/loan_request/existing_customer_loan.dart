// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/data/view_model/loan_view_model.dart';
import 'package:nkrs_app/models/installment_model.dart';
import 'package:nkrs_app/models/user_loan_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request/loan_details/existing_customer_loan_details.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request/existing_customer_loan_request.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_row.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_text_field.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/loading_dialog.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/popup_box_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_app_bar.dart';

class ExistingCustomerLoan extends StatefulWidget {
  const ExistingCustomerLoan({super.key});

  @override
  State<ExistingCustomerLoan> createState() => _ExistingCustomerLoanState();
}

class _ExistingCustomerLoanState extends State<ExistingCustomerLoan> {
  bool showDetails = false;
  late bool isLoading = false;

  TextEditingController nicNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic _user;

  @override
  void initState() {
    super.initState();
    CheckConnection.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Existing Customer Loan",
        onBackPressed: () => Navigator.pop(context),
      ),
      backgroundColor: safeAreaC,
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
                Text(
                  "Existing Customer Loan",
                  style: TextStyle(
                    fontWeight: FontWeight(HeaderFW),
                    fontSize: headerFontSize,
                    color: headerTextC,
                    // letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Loan Management for Existing Customers",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: cardDescriptionFS,
                    fontWeight: FontWeight(descriptionFw),
                    color: descriptionC,
                    // letterSpacing:
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: appBarC,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    boxShadow: [MainCard.customShadow()],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Search for Customer".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight(500),
                          color: const Color.fromARGB(138, 26, 26, 26),
                        ),
                      ),
                      SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 240,
                              child: CustomTextField(
                                controllerNames: nicNumber,
                                labelText_: "Enter Customer ID",
                                type: TextInputType.number,
                                validatorCallback: (value) {
                                  if (value == null) {
                                    return "Please fill this field";
                                  } else if (value.isEmpty) {
                                    return "Enter a valid NIC number";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  try {
                                    _user = await LoanViewModel()
                                        .findUserAndLoanById(
                                          context,
                                          int.parse(nicNumber.text.trim()),
                                        );
                                    if (_user != null) {
                                      setState(() {
                                        showDetails = true;
                                      });
                                    } else {
                                      setState(() {
                                        showDetails = false;
                                        _user = null;
                                      });
                                      AppTopSnackBar.error(
                                        context,
                                        "User not found. Please check the ID.",
                                      );
                                    }
                                  } catch (e) {
                                    setState(() {
                                      showDetails = false;
                                      _user = null;
                                    });
                                    AppTopSnackBar.error(
                                      context,
                                      "Something went wrong. Please try again.",
                                    );
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                // ignore: deprecated_member_use
                                backgroundColor: const Color.fromARGB(
                                  96,
                                  0,
                                  102,
                                  255,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    btnBorderRadius,
                                  ),
                                  side: BorderSide(
                                    width: 2,
                                    // ignore: deprecated_member_use
                                    color: btnC.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              child: isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "FIND",
                                      style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white,
                                        fontSize: btnFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                customBox(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customBox() {
    if (showDetails) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Active & Past Loans",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A3D81),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsetsDirectional.all(20),
            decoration: BoxDecoration(
              color: appBarC,
              borderRadius: BorderRadius.circular(cardBorderRadius),
              boxShadow: [MainCard.customShadow()],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(_user!.name),
                CustomRow(label: "Full Name", value: _user!.name),
                CustomRow(label: "Address", value: _user!.address),
                CustomRow(label: "Phone Number", value: _user!.phoneNumber),
                GestureDetector(
                  onTap: () async {
                    // if (_user.loan?.length < 3) {
                    List<InstallmentModel>? installments;
                    // List<InterestRateModel>? interestRate;
                    LoadingDialog.show(context, message: 'Please Wait...');
                    try {
                      installments = await LoanViewModel().getInstallmentInfo(
                        context,
                      );
                    } catch (e) {
                      // handle/log error if you want
                    } finally {
                      if (context.mounted) {
                        LoadingDialog.hide(context);
                      }
                    }
                    if (!context.mounted) return;
                    if (installments != null && installments.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExistingCustomerLoanRequest(
                            installments: installments!,
                            interestRates: null,
                            nicNumber: int.tryParse(nicNumber.text.trim()) ?? 0,
                          ),
                        ),
                      );
                    } else {
                      AppTopSnackBar.error(
                        context,
                        "Failed to load installments. Cannot proceed.",
                      );
                    }
                    // }
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
                          "Request New Loan",
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
          SizedBox(height: 20),
          FutureBuilder<List<UserLoanModel>>(
            future: Future.value(_user?.loans), //getter
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text("Errors "));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "This user does not have any loan records.",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 72, 56, 56),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    UserLoanModel loan = snapshot.data![index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        border: Border.all(color: Colors.blue.withOpacity(0.1)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          // ignore: deprecated_member_use
                          backgroundColor: const Color(
                            0xFF1A3D81,
                            // ignore: deprecated_member_use
                          ).withOpacity(0.1),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFF1A3D81),
                          ),
                        ),
                        title: Text(
                          "Loan ID : ${loan.fileNumber.toString()}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A3D81),
                          ),
                        ),
                        subtitle: Text(
                          "Issued: ${loan.createdAt.split('T')[0]}",
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "LKR ${loan.amount.toString()}",
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
                                color: switch (loan.status.toString()) {
                                  'APPROVED' => Colors.green[50],
                                  'PENDING' => const Color.fromARGB(
                                    255,
                                    255,
                                    238,
                                    225,
                                  ),
                                  'REJECTED' => Colors.red[50],
                                  _ => Colors.grey[100],
                                },
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                loan.status.toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: switch (loan.status) {
                                    'APPROVED' => Colors.green[700],
                                    'PENDING' => Colors.amber[600],
                                    'REJECTED' => Colors.red[700],
                                    _ => Colors.grey[600],
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoanDetailsPage(loan: loan),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
