import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/data/view_model/loan_view_model.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request/existing_customer_loan_details.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request/existing_customer_loan_request.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/popup_box_message.dart';

class ExistingCustomerLoan extends StatefulWidget {
  const ExistingCustomerLoan({super.key});

  @override
  State<ExistingCustomerLoan> createState() => _ExistingCustomerLoanState();
}

class _ExistingCustomerLoanState extends State<ExistingCustomerLoan> {
  bool showDetails = false;

  LoanViewModel loanData = LoanViewModel();
  TextEditingController nicNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String message = '';
  late final User? _user;

  @override
  void initState() {
    super.initState();
    // DatabaseService().database;
    DatabaseService().printAllTables();
    DatabaseService().isTableExists("");
  }

  @override
  Widget build(BuildContext context) {
    late int? customerID;

    return Scaffold(
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: safeAreaHorizontalPD,
            vertical: safeAreaVerticalPD,
          ),
          child: SingleChildScrollView(
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
                        "Search for Customer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight(800),
                          color: const Color.fromARGB(156, 26, 26, 26),
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
                              height: 100,
                              child: TextFormField(
                                controller: nicNumber,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                cursorColor: const Color.fromARGB(
                                  255,
                                  0,
                                  55,
                                  255,
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
                                  labelText: "Enter Customer ID",
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(105, 21, 21, 21),
                                    fontSize: 17,
                                    fontWeight: FontWeight(500),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please fill this field";
                                  } else if (value.length < 0) {
                                    return "Enter a valid NIC number";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (newValue) {
                                  customerID = int.tryParse(nicNumber.text);
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // database();
                                bool online =
                                    await CheckConnection.isInternet();

                                if (online) {
                                  print("Internet Available");
                                } else {
                                  print("No Internet");
                                }
                                if (!_formKey.currentState!.validate()) return;

                                final customerId = int.tryParse(
                                  nicNumber.text.trim(),
                                );
                                // if (customerId == null) {
                                //   setState(() {
                                //     showDetails = false;
                                //     message =
                                //         "Please enter a valid numeric customer ID.";
                                //   });
                                //   return;
                                // }

                                await loanData.searchByNic(customerId!);
                                _user = loanData.user;

                                setState(() {
                                  if (_user != null) {
                                    showDetails = true;
                                    message = '';
                                  } else {
                                    showDetails = false;
                                    message = "No matching user was found";
                                  }
                                });
                                showTopNotification(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  "Please fix the validation errors before submitting.",
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnC,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    btnBorderRadius,
                                  ),
                                ),
                              ),
                              child: Text(
                                "FIND",
                                style: TextStyle(
                                  letterSpacing: 2,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontSize: btnFontSize,
                                  fontWeight: FontWeight(500),
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
    // User? user = loanData.user;
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
                _buildDetailRow("Full Name", _user!.name),
                _buildDetailRow("Address", _user.address),
                // _buildDetailRow("Email", "_user.email"),
                _buildDetailRow("Phone Number", _user.phoneNumber),
                GestureDetector(
                  onTap: () {
                    // Navigate to new loan request page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExistingCustomerLoanRequest(nicNumber: 1255654),
                      ),
                    );
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
          FutureBuilder<List<Loan>>(
            future: loanData.getLoansByID(), //getter
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
                    Loan loan = snapshot.data![index];
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
                          "Issued: ${loan.createdAt?.split(' ')[0]}",
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
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 8,
                            //     vertical: 2,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color:
                            //         loan.status.toString().toLowerCase() ==
                            //             "active"
                            //         ? Colors.green[50]
                            //         : Colors.grey[100],
                            //     borderRadius: BorderRadius.circular(5),
                            //   ),
                            //   child: Text(
                            //     loan.status.toString().toLowerCase(),
                            //     style: TextStyle(
                            //       fontSize: 10,
                            //       fontWeight: FontWeight.bold,
                            //       color:
                            //           loan.status.toString().toLowerCase() ==
                            //               "active"
                            //           ? Colors.green[700]
                            //           : Colors.grey[600],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoanDetailsPage(),
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
      nicNumber.clear();
      // nicNumber.dispose();
      return Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 205, 8, 8),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  void showCustomMessageBox(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    // 1. Clear any existing snackbars instantly
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating, // Floats above bottom navigation
        backgroundColor: Colors.white,
        elevation: 6,

        // 2. Set the automatic close time to 10 seconds
        duration: const Duration(seconds: 10),

        // 3. Custom Physics/Animation Settings
        dismissDirection:
            DismissDirection.horizontal, // Allows swiping away to close

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isError
                ? Colors.black
                : Colors.black12, // Bold border for errors
            width: isError ? 2.0 : 1.0,
          ),
        ),
        content: Row(
          children: [
            // Animated Icon swap based on state
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                key: ValueKey<bool>(isError),
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: "DISMISS",
          textColor: Colors.black87,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void database() async {
    // await DatabaseService().insertCustomer(
    //   address: "116/3",
    //   email: "example@gmail.com",
    //   name: "vihaga",
    //   nic: 200210801480,
    //   phoneNumber: "07766303438",
    // );
    // await DatabaseService().insertCustomer(
    //   address: "116/3",
    //   email: "example2@gmail.com",
    //   name: "vihaga",
    //   nic: 200210801481,
    //   phoneNumber: "07766303438",
    // );
    await DatabaseService().deleteCustomerByNic(200210801481);
    await DatabaseService().getAllCustomers();
    // await DatabaseService().printAllTables();
    // await DatabaseService().isTableExists("");
    // await DatabaseService().dropTables();
    // await DatabaseService().deleteDatabaseFile();
    // DatabaseService().close();
  }
}
