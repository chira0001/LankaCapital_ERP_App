import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:timeline_tile/timeline_tile.dart';

class NewClientLoanRequestStatus extends StatefulWidget {
  const NewClientLoanRequestStatus({super.key});

  @override
  State<NewClientLoanRequestStatus> createState() =>
      _NewClientLoanRequestStatusState();
}

class _NewClientLoanRequestStatusState
    extends State<NewClientLoanRequestStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        shadowColor: appBarShadow,
        backgroundColor: appBarC,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoanRequestSection()),
                (Route<dynamic> route) => false,
              );
            },
            icon: Icon(
              Icons.close,
              color: const Color.fromARGB(255, 0, 0, 0),
              size: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        title: Text("Loan Request Status"),
        titleTextStyle: TextStyle(
          color: btnC,
          fontSize: appBarFontS,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: safeAreaC,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: safeAreaHorizontalPD,
              vertical: safeAreaVerticalPD,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: safeAreaC,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Loan Request",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight(HeaderFW),
                                    fontSize: cardHeaderFS,
                                    color: cardHeaderFC,
                                  ),
                                ),
                                Text(
                                  "Your loan request",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: cardDescriptionFS,
                                    // fontWeight: descriptionFw,
                                    color: cardDescriptionFC,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(21, 255, 149, 0),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color.fromARGB(144, 255, 149, 0),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.pending_rounded,
                                    color: Color.fromARGB(255, 255, 149, 0),
                                    size: 12,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Pending",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 206, 126, 13),
                                      fontSize: 14,
                                      fontWeight: FontWeight(600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "Customer Name",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: btnFontSize,
                                  color: cardDescriptionFC,
                                  fontWeight: FontWeight(600),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                "John Doe",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: descriptionFontSize,
                                  fontWeight: FontWeight(HeaderFW),
                                  color: cardHeaderFC,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(31, 108, 108, 108),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Loan Lifecycle",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight(HeaderFW),
                          fontSize: cardHeaderFS,
                          color: cardHeaderFC,
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _customTimeLine(
                            false,
                            false,
                            true,
                            "Request Submitted",
                            "Your loan request has been submitted and is under review.",
                          ),
                          _customTimeLine(
                            false,
                            false,
                            false,
                            "Document Verification",
                            "Please provide the required documents for verification.",
                          ),
                          _customTimeLine(
                            false,
                            true,
                            false,
                            "Loan Approved",
                            "Congratulations! Your loan request has been approved.",
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
      ),
    );
  }

  SizedBox _customTimeLine(
    final bool isFirst,
    final bool isLast,
    final bool isActive,
    final String title,
    final String description,
  ) {
    return SizedBox(
      height: 130,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        hasIndicator: true,
        indicatorStyle: IndicatorStyle(
          height: 28,
          width: 28,
          padding: EdgeInsets.all(5),
          color: isActive
              ? const Color.fromARGB(255, 0, 188, 44)
              : const Color.fromARGB(71, 108, 108, 108),
          iconStyle: IconStyle(
            color: appBarC,
            fontSize: 20,
            iconData: isActive ? Icons.check : Icons.recycling,
          ),
        ),
        afterLineStyle: LineStyle(
          color: isActive
              // ignore: deprecated_member_use
              ? btnC.withOpacity(0.7)
              : const Color.fromARGB(71, 108, 108, 108),
          thickness: isActive ? 2 : 1,
        ),
        beforeLineStyle: LineStyle(
          color: isActive
              // ignore: deprecated_member_use
              ? btnC.withOpacity(0.7)
              : const Color.fromARGB(71, 108, 108, 108),
          thickness: isActive ? 2 : 1,
        ),
        endChild: Container(
          height: 92,
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            color: appBarC,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // "Loan Request Submitted",
                title,
                style: TextStyle(
                  fontSize: cardHeaderFS - 3,
                  fontWeight: FontWeight(HeaderFW),
                  color: cardHeaderFC,
                ),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: cardDescriptionFS - 1,
                  fontWeight: FontWeight(600),
                  color: cardDescriptionFC,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Row _customRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Flexible(
  //         flex: 1,
  //         child: Text(
  //           "Customer Name",
  //           textAlign: TextAlign.left,
  //           style: TextStyle(
  //             fontSize: btnFontSize,
  //             color: cardDescriptionFC,
  //             fontWeight: FontWeight(600),
  //           ),
  //         ),
  //       ),
  //       Flexible(
  //         flex: 1,
  //         child: Text(
  //           "John Doe",
  //           textAlign: TextAlign.right,
  //           style: TextStyle(
  //             fontSize: descriptionFontSize,
  //             fontWeight: FontWeight(HeaderFW),
  //             color: cardHeaderFC,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}


// child: ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   itemCount: 5,
                        //   itemBuilder: (context, index) {
                        //     return _customTimeLine(index == 0, index == 4);
                        //   },
                        // ),