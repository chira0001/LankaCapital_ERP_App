import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/new_client_loan_request_status.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';

class NewClientLoanRequest extends StatefulWidget {
  const NewClientLoanRequest({super.key});

  @override
  State<NewClientLoanRequest> createState() => _NewClientLoanRequestState();
}

class _NewClientLoanRequestState extends State<NewClientLoanRequest> {
  // File? nicFront;
  // File? nicBack;

  final _formKey = GlobalKey<FormState>();
  // for step
  final TextEditingController name = TextEditingController();
  final TextEditingController nic = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  // final TextEditingController password = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  final TextEditingController loanAmount = TextEditingController();
  final TextEditingController interestRate = TextEditingController();

  // for step 2
  int _currentStep = 0;
  final double _customSize_1 = 10;
  final double _customSize_2 = 20;
  bool isCompeleted = false;

  List<Step> get getSt => [
    Step(
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 0,
      title: Text(""),
      content: Container(
        margin: EdgeInsets.only(bottom: 30),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: appBarC,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          boxShadow: [MainCard.customShadow()],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Iconsax.user, size: 30, color: btnC),
                SizedBox(width: 10),
                Text(
                  "Personal Details",
                  style: TextStyle(
                    fontSize: cardHeaderFS,
                    color: cardHeaderFC,
                    fontWeight: FontWeight(700),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            customText("Full Name"),
            SizedBox(height: _customSize_1),
            _customBuild(name, "John Doe", TextInputType.text, (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your name";
              } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                return "Name cannot contain only numbers or special characters";
              } else {
                return null;
              }
            }),
            SizedBox(height: _customSize_2),
            customText("Address"),
            SizedBox(height: _customSize_1),
            _customBuild(address, "No: 123, Street Name", TextInputType.text, (
              value,
            ) {
              if (value == null || value.isEmpty) {
                return "Please enter your address";
              } else if (value.length < 5) {
                return "Please enter a valid address";
              } else {
                return null;
              }
            }),
            SizedBox(height: _customSize_2),
            customText("E-mail"),
            SizedBox(height: _customSize_1),
            _customBuild(
              email,
              "Example@email.com",
              TextInputType.emailAddress,
              (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                } else if (!RegExp(
                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                ).hasMatch(value)) {
                  return "Please enter a valid email address";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: _customSize_2),
            customText("NIC Number"),
            SizedBox(height: _customSize_1),
            _customBuild(nic, "Enter NIC Number", TextInputType.text, (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your NIC number";
              } else if (value.length < 8 && value.length > 15) {
                return "Please enter a valid NIC number";
              } else {
                return null;
              }
            }),
            SizedBox(height: _customSize_2),
            customText("Phone Number"),
            SizedBox(height: _customSize_1),
            _customBuild(phoneNumber, "0712345678", TextInputType.phone, (
              value,
            ) {
              if (value == null || value.isEmpty) {
                return "Please enter your phone number";
              } else if (value.length != 10 || !value.startsWith('07')) {
                return "Please enter a valid phone number";
              } else {
                return null;
              }
            }),
          ],
        ),
      ),
    ),
    Step(
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 1,
      title: Text(""),
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: appBarC,
              borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
              boxShadow: [MainCard.customShadow()],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Iconsax.user, size: 30, color: btnC),
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
                _customBuild(loanAmount, "XXXXX.XX", TextInputType.number, (
                  value,
                ) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the loan amount";
                  } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                    return "Please enter a valid loan amount";
                  } else {
                    return null;
                  }
                }),
                SizedBox(height: _customSize_2),
                customText("Interest Rate"),
                SizedBox(height: _customSize_1),
                _customBuild(interestRate, "XX.XX%", TextInputType.number, (
                  value,
                ) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the interest rate";
                  } else if (!RegExp(r'^\d+(\.\d+)?%?$').hasMatch(value)) {
                    return "Please enter a valid interest rate";
                  } else if (value == 100) {
                    return "Please enter an interest rate between 0 and 100";
                  } else {
                    return null;
                  }
                }),
                SizedBox(height: _customSize_2),
                customText("Loan Duration"),
                SizedBox(height: _customSize_1),
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        hint: Text("Choose Loan Duration"),
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
                          labelText: "labelText_",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(105, 21, 21, 21),
                            fontSize: 17,
                            fontWeight: FontWeight(500),
                          ),
                        ),
                        items: ["6 Months", "12 Months", "24 Months"].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Color(0xFF1A3D81)),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          // Logic to update Monthly Payment based on duration
                        },
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

    Step(
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 2,
      title: Text(""),
      content: Container(
        margin: EdgeInsets.only(bottom: 30),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: appBarC,
          borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
          boxShadow: [MainCard.customShadow()],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Iconsax.document_favorite, size: 30, color: btnC),
                SizedBox(width: 10),
                Text(
                  "Summary Details",
                  style: TextStyle(
                    fontSize: cardHeaderFS,
                    color: cardHeaderFC,
                    fontWeight: FontWeight(700),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Full Name", name.text),
                  Row(
                    children: [
                      Expanded(child: _buildDetailRow("NIC Number", nic.text)),
                      Expanded(
                        child: _buildDetailRow("Phone", phoneNumber.text),
                      ),
                    ],
                  ),
                  _buildDetailRow("Email", email.text),
                  _buildDetailRow("Permanent Address", address.text),
                ],
              ),
            ),
            SizedBox(height: 20), // Space between boxes
            // --- BOX 2: LOAN BREAKDOWN ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  _buildLoanRow("Principal Amount", "LKR 250,000.00"),
                  _buildLoanRow("Interest Rate (Annual)", "14.5%"),
                  _buildLoanRow("Installment Count", "24 Months"),
                  Divider(height: 30),
                  _buildLoanRow(
                    "Monthly Payment",
                    "LKR 12,065.50",
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarC,
        leading: IconButton(
          onPressed: () {
            _showMySheet(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        title: Text("New Client Loan Request"),
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
      body: SafeArea(
        child: Container(
          color: safeAreaC,
          child: Form(
            key: _formKey,
            child: Stepper(
              type: StepperType.horizontal,
              steps: getSt,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    final isLastStep = _currentStep == getSt.length - 1;
                    if (isLastStep) {
                      // ignore: avoid_print
                      print("All steps valid. Submitting to Database...");

                      // Call your database method here
                      // Dispose/Reset variables if needed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewClientLoanRequestStatus(),
                        ),
                      );
                    } else {
                      // Logic for moving to the next step
                      _currentStep += 1;
                    }
                  });
                } else {
                  // ignore: avoid_print
                  print(
                    "Validation failed. Please fix the errors in the form.",
                  );
                }
              },
              onStepCancel: () {
                _currentStep == 0
                    ? null
                    : setState(() {
                        _currentStep -= 1;
                      });
              },
              onStepTapped: (value) {
                setState(() {
                  _currentStep = value;
                });
              },
              controlsBuilder: (context, details) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnC,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(btnBorderRadius),
                        ),
                      ),
                      onPressed: details.onStepContinue,
                      child: Text(
                        _currentStep == getSt.length - 1 ? "Finish" : "Next",
                        style: TextStyle(
                          color: appBarC,
                          fontSize: btnFontSize,
                          fontWeight: FontWeight(HeaderFW),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 10),
                  if (_currentStep > 0)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBarC,
                          side: BorderSide(width: 2, color: btnC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              btnBorderRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: btnFontSize,
                            fontWeight: FontWeight(HeaderFW),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              connectorThickness: 1,
              // stepIconWidth: 40,
            ),
          ),
        ),
      ),
    );
    // name.clear();
  }

  Widget _customBuild(
    final TextEditingController controllerNames,
    final String labelText_,
    final TextInputType? type,
    final String? Function(String?)? validatorCallback,
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

  void _showMySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.37,
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Iconsax.warning_2_copy,
                  color: const Color.fromARGB(164, 175, 6, 6),
                  size: 43,
                  fontWeight: FontWeight(700),
                  shadows: [
                    Shadow(
                      blurRadius: 60,
                      color: const Color.fromARGB(255, 252, 0, 0),
                    ),
                  ],
                ),
                Text(
                  "Are you sure?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight(HeaderFW),
                  ),
                ),
                Text(
                  "You have unsaved changes. If you leave now, your progress will be lost.",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight(descriptionFw),
                    // ignore: deprecated_member_use
                    color: descriptionC.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.39,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoanRequestSection(),
                            ),
                            (Route<dynamic> route) =>
                                false, // 'false' clears the entire history
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: btnC,
                            borderRadius: BorderRadius.circular(
                              btnBorderRadius,
                            ),
                          ),
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: 10,
                          ),
                          child: Text(
                            "HOME",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: btnFontSize,
                              fontWeight: FontWeight(HeaderFW),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.39,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: appBarC,
                            borderRadius: BorderRadius.circular(
                              btnBorderRadius,
                            ),
                            border: Border.all(color: btnC, width: 2),
                          ),
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: 10,
                          ),
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: btnFontSize,
                              fontWeight: FontWeight(HeaderFW),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.transparent),
              ],
            ),
          ),
        );
      },
    );
  }

  // AppBar customAppBar() {
  //   return AppBar(
  //     backgroundColor: appBarC,
  //     leading: IconButton(
  //       onPressed: () {
  //         _showMySheet(context);
  //       },
  //       icon: Icon(
  //         Icons.arrow_back_ios,
  //         color: const Color.fromARGB(255, 0, 0, 0),
  //         size: 25,
  //         fontWeight: FontWeight.w900,
  //       ),
  //     ),
  //     title: Text("New Client Loan Request"),
  //     titleTextStyle: TextStyle(
  //       color: btnC,
  //       fontSize: 22,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     actions: [
  //       Padding(
  //         padding: EdgeInsets.only(right: 10),
  //         child: IconButton(
  //           onPressed: () {},
  //           icon: Icon(
  //             Icons.help_outline,
  //             color: const Color.fromARGB(118, 17, 17, 17),
  //             size: 26,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildUploadBox(String title, File? image, bool isFront) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(title),
        SizedBox(height: _customSize_1),
        GestureDetector(
          // onTap: () => pickImage(isFront),
          child: Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: safeAreaC,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color.fromARGB(58, 23, 23, 23),
                width: 1.5,
              ),
            ),
            child: image == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.document_upload_copy, size: 30),
                      SizedBox(height: 5),
                      Text("Tap to upload"),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void controllerClear() {
    name.clear();
    nic.clear();
    email.clear();
    address.clear();
    phoneNumber.clear();
  }

  Widget _buildLoanRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF1A3D81),
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF1A3D81),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
