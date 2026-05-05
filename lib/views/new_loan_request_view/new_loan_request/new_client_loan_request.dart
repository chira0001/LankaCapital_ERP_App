import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/main.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/new_client_loan_request_status.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';

class NewClientLoanRequest extends StatefulWidget {
  const NewClientLoanRequest({super.key});

  @override
  State<NewClientLoanRequest> createState() => _NewClientLoanRequestState();
}

class _NewClientLoanRequestState extends State<NewClientLoanRequest> {
  File? nicFront;
  File? nicBack;

  final _formKey = GlobalKey<FormState>();
  // for step
  final TextEditingController name = TextEditingController();
  final TextEditingController nic = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  // for step 2

  int _currentStep = 0;
  final double _customSize_1 = 10;
  final double _customSize_2 = 25;
  bool isCompeleted = false;

  List<Step> get getSt => [
    Step(
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 0,
      title: Text(""),
      content: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: appBarC,
            borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
            boxShadow: [MainCard.customShadow()],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              _customBuild(name, "Enter Customer Name", (value) {
                if (value == null || value.isEmpty) {
                  return "Incorrect";
                } else {
                  return null;
                }
              }),
              SizedBox(height: _customSize_2),
              customText("Full Name"),
              SizedBox(height: _customSize_1),
              _customBuild(nic, "Enter Customer ID", (value) => null),
              SizedBox(height: _customSize_2),
              customText("E-mail"),
              SizedBox(height: _customSize_1),
              _customBuild(email, "Enter Customer ID", (value) => null),
              SizedBox(height: _customSize_2),
              customText("Address"),
              SizedBox(height: _customSize_1),
              _customBuild(address, "Enter Customer ID", (value) => null),
              // SizedBox(height: _customSize_1),
            ],
          ),
        ),
      ),
    ),
    Step(
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 1,
      title: Text(""),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: appBarC,
                borderRadius: BorderRadius.all(
                  Radius.circular(cardBorderRadius),
                ),
                boxShadow: [MainCard.customShadow()],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.credit_card, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        "NIC Details",
                        style: TextStyle(
                          color: cardHeaderFC,
                          fontSize: cardHeaderFS,
                          fontWeight: FontWeight(700),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _customSize_2),
                  buildUploadBox("NIC Front Side", nicFront, true),
                  SizedBox(height: _customSize_2),
                  buildUploadBox("NIC Back Side", nicBack, false),
                ],
              ),
            ),
          ],
        ),
      ),
    ),

    Step(
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 2,
      title: Text(""),
      content: Column(),
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
    final String? Function(String?)? validatorCallback,
  ) {
    return TextFormField(
      controller: controllerNames,
      keyboardType: TextInputType.number,
      autocorrect: false,
      cursorColor: const Color.fromARGB(255, 0, 55, 255),
      decoration: InputDecoration(
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
            color: Color.fromARGB(148, 181, 0, 0),
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
                              builder: (context) => const MyApp(),
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
}
