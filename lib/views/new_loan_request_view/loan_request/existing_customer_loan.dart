import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request/existing_customer_loan_request.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/new_client_loan_request.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
// import 'package:http/http.dart' as http;

class ExistingCustomerLoan extends StatefulWidget {
  const ExistingCustomerLoan({super.key});

  // Future<void> _showMySheet(BuildContext context) async {
  //   String url =
  //       "https://www.lankacapital.lk/api/submit"; // Ensure the path is correct

  //   try {
  //     var response = await http.post(
  //       Uri.parse(url),
  //       body: {"name": "John Doe", "email": "john.doe@example.com"},
  //     );

  //     if (response.statusCode == 200) {
  //       // Success: Add logic to handle the server response
  //       print("Data Sent Successfully: ${response.body}");
  //     } else {
  //       // Handle server errors
  //       print("Server Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     // Handle network errors
  //     print("Connection Error: $e");
  //   }
  // }

  @override
  State<ExistingCustomerLoan> createState() => _ExistingCustomerLoanState();
}

class _ExistingCustomerLoanState extends State<ExistingCustomerLoan> {
  bool showDetails = false;

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
    {
      "id": "L-7712",
      "amount": "LKR 120,000.00",
      "date": "2025-05-20",
      "status": "Closed",
    },
    {
      "id": "L-7712",
      "amount": "LKR 120,000.00",
      "date": "2025-05-20",
      "status": "Closed",
    },
  ];

  TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
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
                // height: 200,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appBarC,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  boxShadow: [MainCard.customShadow()],
                  // backgroundBlendMode: BlendMode.lighten,
                  // border: BoxBorder.all(
                  //   color: const Color.fromARGB(88, 175, 175, 175),
                  //   width: 1,
                  // ),
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
                      // key: ;,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 240,
                            height: 50,
                            child: TextFormField(
                              controller: address,
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
                              // validator: validatorCallback,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showDetails = true;
                              });
                              // showAboutDialog(
                              //   context: context,
                              //   children: [
                              //     Text("Customer ID: 123456"),
                              //     Text("Name: John Doe"),
                              //     Text("Loan Status: Active"),
                              //   ],
                              // );
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => CustomDialogBox(
                              //     leftBtn: () {
                              //       Navigator.pushAndRemoveUntil(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) =>
                              //               const MyApp(), //navigate to home page
                              //         ),
                              //         (Route<dynamic> route) => false,
                              //       );
                              //     },
                              //     rightBtn: () {
                              //       Navigator.pop(context);
                              //     },
                              //     // ignore: deprecated_member_use
                              //     imageBColor: btnC.withOpacity(0.4),
                              //     header: "Loan Approved !",
                              //     description:
                              //         "You can now proceed with the next steps in the loan process.",
                              //     imageURL: 'assets/images/success-icon.png',
                              //   ),
                              // );
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
                                color: const Color.fromARGB(255, 255, 255, 255),
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
          GestureDetector(
            onTap: () {
              // Navigate to new loan request page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExistingCustomerLoanRequest(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
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
                    backgroundColor: const Color(0xFF1A3D81).withOpacity(0.1),
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
      );
    } else {
      // A function must return a widget in all paths
      return const SizedBox.shrink();
    }
  }
}
