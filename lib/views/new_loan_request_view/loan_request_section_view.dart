import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/customer_collection_home.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request/existing_customer_loan.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/new_client_loan_request.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/popup_box_message.dart';

class LoanRequestSection extends StatefulWidget {
  const LoanRequestSection({super.key});

  @override
  State<LoanRequestSection> createState() => _LoanRequestSectionState();
}

class _LoanRequestSectionState extends State<LoanRequestSection> {
  double logoSize = 32;

  @override
  void initState() {
    super.initState();
    CheckConnection.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo/logo_1.png',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Text("Lanka Capital"),
          ],
        ),
        centerTitle: true,
        backgroundColor: appBarC,
        elevation: 2.0,
        shadowColor: appBarShadow,
        leading: GestureDetector(
          onTap: () {
            // Navigator.pop(context);
          },
          child: IconButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerCollectionHome(),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: const Color.fromARGB(255, 0, 0, 0),
              size: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        titleTextStyle: TextStyle(
          color: btnC,
          fontSize: appBarFontS,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            // ValueListenableBuilder automatically rebuilds ONLY when the connection state updates
            child: ValueListenableBuilder<bool>(
              valueListenable: CheckConnection.isOnline,
              builder: (context, online, child) {
                return IconButton(
                  onPressed: () {
                    CheckConnection.initialize();
                    showTopNotification(
                      context,
                      online ? "Device is Online" : "Device is Offline",
                    );
                  },
                  icon: Icon(
                    online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                    color: online
                        ? const Color.fromARGB(
                            255,
                            9,
                            172,
                            58,
                          ) // Green when online
                        : const Color.fromARGB(
                            255,
                            172,
                            9,
                            9,
                          ), // Red when offline
                    size: 28,
                  ),
                );
              },
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Loan Request",
                    style: TextStyle(
                      fontWeight: FontWeight(HeaderFW),
                      fontSize: headerFontSize - 1,
                      color: headerTextC,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Select the customer type to continue.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      fontWeight: FontWeight(descriptionFw),
                      color: descriptionC,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              InkWell(
                borderRadius: BorderRadius.circular(cardBorderRadius),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExistingCustomerLoan(),
                    ),
                  );
                },
                child: MainCard(
                  header: "Existing Customer",
                  description:
                      "Process a new loan for a returning client with existing records in our system.",
                  cusIconRight: Iconsax.user_search_copy,
                  iconColor: const Color.fromARGB(255, 0, 55, 255),
                  iconBackgrouundColor: Color.fromARGB(40, 0, 55, 254),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewClientLoanRequest(),
                      // builder: (context)=> LoanSuccessScreen(),
                    ),
                  );
                },
                child: MainCard(
                  header: "New Customer",
                  description:
                      "Register and create a loan application   for a first-time borrower.",
                  cusIconRight: Iconsax.user_add_copy,
                  iconColor: const Color.fromARGB(255, 153, 0, 255),
                  iconBackgrouundColor: Color.fromARGB(40, 153, 0, 255),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
