import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/new_client_loan_request_status.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/navigator_back.dart';

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
  final TextEditingController installment = TextEditingController();
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
              return null;
            
              // if (value == null || value.isEmpty) {
              //   return "Please enter your address";
              // } else if (value.length < 5) {
              //   return "Please enter a valid address";
              // } else {
              //   return null;
              // }
            }),
            SizedBox(height: _customSize_2),
            customText("E-mail"),
            SizedBox(height: _customSize_1),
            _customBuild(
              email,
              "Example@email.com",
              TextInputType.emailAddress,
              (value) {
                return null;
              
                // if (value == null || value.isEmpty) {
                //   return "Please enter your email";
                // } else if (!RegExp(
                //   r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                // ).hasMatch(value)) {
                //   return "Please enter a valid email address";
                // } else {
                //   return null;
                // }
              },
            ),
            SizedBox(height: _customSize_2),
            customText("NIC Number"),
            SizedBox(height: _customSize_1),
            _customBuild(nic, "Enter NIC Number", TextInputType.text, (value) {
              return null;
            
              // if (value == null || value.isEmpty) {
              //   return "Please enter your NIC number";
              // } else if (value.length < 8 && value.length > 15) {
              //   return "Please enter a valid NIC number";
              // } else {
              //   return null;
              // }
            }),
            SizedBox(height: _customSize_2),
            customText("Phone Number"),
            SizedBox(height: _customSize_1),
            _customBuild(phoneNumber, "0712345678", TextInputType.phone, (
              value,
            ) {
              return null;
            
              // if (value == null || value.isEmpty) {
              //   return "Please enter your phone number";
              // } else if (value.length != 10 || !value.startsWith('07')) {
              //   return "Please enter a valid phone number";
              // } else {
              //   return null;
              // }
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
                  return null;
                
                  // if (value == null || value.isEmpty) {
                  //   return "Please enter the loan amount";
                  // } else if (value as double == 0) {
                  //   return "Please enter a valid loan amount";
                  // } else {
                  //   return null;
                  // }
                }),
                SizedBox(height: _customSize_2),
                customText("Interest Rate"),
                SizedBox(height: _customSize_1),
                _customBuild(interestRate, "XX.XX%", TextInputType.number, (
                  value,
                ) {
                  return null;
                
                  // if (value == null || value.isEmpty) {
                  //   return "Please enter the interest rate";
                  // } else if (value as int < 0) {
                  //   return "Please enter a valid interest rate";
                  // } else if (value as int < 0 || value as int >= 100) {
                  //   return "Please enter an interest rate between 0 and 100";
                  // } else {
                  //   return null;
                  // }
                }),
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
                          return null;
                        
                          // if (value == null || value.isEmpty) {
                          //   return "Please enter the number of installments";
                          // } else if (value as int < 0) {
                          //   return "Please enter a valid number of installments";
                          // } else {
                          //   return null;
                          // }
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
                        items: ["Days", "Weeks", "Months"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Color(0xFF1A3D81)),
                            ),
                          );
                        }).toList(),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "Please select a duration type";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        onChanged: (newValue) {},
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
            SizedBox(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewClientLoanRequestStatus(),
                        ),
                      );
                    } else {
                      setState(() {
                        _currentStep += 1;
                      });
                    }
                  });
                } else {
                  // if (_currentStep == 1) {
                  //   setState(() {
                  //     _currentStep -= 1;
                  //   });
                  // }
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

  void controllerClear() {
    name.clear();
    nic.clear();
    email.clear();
    address.clear();
    phoneNumber.clear();
  }

  @override
  void dispose() {
    name.dispose();
    nic.dispose();
    email.dispose();
    address.dispose();
    phoneNumber.dispose();
    loanAmount.dispose();
    interestRate.dispose();
    installment.dispose();
    super.dispose();
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
