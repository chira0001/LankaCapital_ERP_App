import 'package:flutter/material.dart';
import 'package:nkrs_app/main.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_dialog_box.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarC,
        elevation: 2.0,
        shadowColor: appBarShadow,
        leading: IconButton(
          onPressed: () {
            // _showMySheet(context);
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
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
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
                height: 200,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: const Color.fromARGB(
                        28,
                        29,
                        29,
                        29,
                        // ignore: deprecated_member_use
                      ).withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
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
                      "Customer Verification".toUpperCase(),
                      style: TextStyle(
                        fontSize: cardDescriptionFS,
                        color: cardDescriptionFC,
                        fontWeight: FontWeight(cardDescriptionFW),
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          // width: isMobile(context) ? 200 : 300,
                          width: 240,
                          height: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            cursorColor: const Color.fromARGB(255, 0, 55, 255),
                            decoration: InputDecoration(
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
                              fillColor: safeAreaC,
                              filled: true,
                              labelText: "Enter Customer ID",
                              labelStyle: TextStyle(
                                color: btnC,
                                fontSize: 17,
                                fontWeight: const FontWeight(500),
                              ),
                              // prefixIcon: Icon(Iconsax.user_search_copy),
                              // prefixIconColor: Color.fromARGB(255, 0, 55, 255),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a customer ID';
                              }
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // showAboutDialog(
                            //   context: context,
                            //   children: [
                            //     Text("Customer ID: 123456"),
                            //     Text("Name: John Doe"),
                            //     Text("Loan Status: Active"),
                            //   ],
                            // );
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialogBox(
                                leftBtn: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MyApp(), //navigate to home page
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                rightBtn: () {
                                  Navigator.pop(context);
                                },
                                // ignore: deprecated_member_use
                                imageBColor: btnC.withOpacity(0.4),
                                header: "Loan Approved !",
                                description:
                                    "You can now proceed with the next steps in the loan process.",
                                imageURL: 'assets/images/success-icon.png',
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnC,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 13,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
