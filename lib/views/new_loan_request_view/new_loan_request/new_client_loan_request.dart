import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/models/Interest_rate_model.dart';
import 'package:nkrs_app/models/installments_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/new_client_loan_request_status.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_drop_down.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_row.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_text_field.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/navigator_back.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/popup_box_message.dart';

class NewClientLoanRequest extends StatefulWidget {
  final List<InstallmentsModel> installments;
  final List<InterestRateModel>? interestRates;
  const NewClientLoanRequest({
    super.key,
    required this.installments,
    required this.interestRates,
  });

  @override
  State<NewClientLoanRequest> createState() => _NewClientLoanRequestState();
}

class _NewClientLoanRequestState extends State<NewClientLoanRequest> {
  @override
  void initState() {
    super.initState();
    CheckConnection.initialize();
  }

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
  final double _customSize_1 = 4;
  final double _customSize_2 = 25;
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
            CustomTextField(
              controllerNames: name,
              labelText_: "John Doe",
              validatorCallback: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your name";
                } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return "Name cannot contain only numbers or special characters";
                } else {
                  return null;
                }
              },
              type: TextInputType.text,
            ),
            SizedBox(height: _customSize_2),
            customText("Address"),
            SizedBox(height: _customSize_1),
            CustomTextField(
              controllerNames: address,
              labelText_: "No: 123, Street Name",
              type: TextInputType.text,
              validatorCallback: (value) {
                return null;
                // if (value == null || value.isEmpty) {
                //   return "Please enter your address";
                // } else if (value.length < 5) {
                //   return "Please enter a valid address";
                // } else {
                //   return null;
                // }
              },
            ),
            SizedBox(height: _customSize_2),
            customText("E-mail"),
            SizedBox(height: _customSize_1),
            CustomTextField(
              controllerNames: email,
              labelText_: "Example@email.com",
              type: TextInputType.emailAddress,
              validatorCallback: (value) {
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
            CustomTextField(
              controllerNames: nic,
              labelText_: "Enter NIC Number",
              type: TextInputType.number,
              validatorCallback: (value) {
                return null;
                // if (value == null || value.isEmpty) {
                //   return "Please enter your NIC number";
                // } else if (value.length < 8 && value.length > 15) {
                //   return "Please enter a valid NIC number";
                // } else {
                //   return null;
                // }
              },
            ),
            SizedBox(height: _customSize_2),
            customText("Phone Number"),
            SizedBox(height: _customSize_1),
            CustomTextField(
              controllerNames: phoneNumber,
              labelText_: "0712345678",
              type: TextInputType.phone,
              validatorCallback: (value) {
                return null;
                // if (value == null || value.isEmpty) {
                //   return "Please enter your phone number";
                // } else if (value.length != 10 || !value.startsWith('07')) {
                //   return "Please enter a valid phone number";
                // } else {
                //   return null;
                // }
              },
            ),
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
                CustomTextField(
                  controllerNames: loanAmount,
                  labelText_: "XXXXX.XX",
                  type: TextInputType.number,
                  validatorCallback: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the loan amount";
                    } else if (value as double == 0) {
                      return "Please enter a valid loan amount";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: _customSize_2),
                customText("Loan Type"),
                SizedBox(height: _customSize_1),
                CustomDropDown<int>(
                  hint: "-- --",
                  btnBorderRadius: btnBorderRadius,
                  safeAreaC: safeAreaC,
                  items: widget.installments.map((item) {
                    return DropdownMenuItem<int>(
                      value: item.id.toInt(),
                      child: Text(item.value.toString()),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Please select Loan type";
                    }
                    return null;
                  },
                  onChanged: (int? newValue) {
                    print(newValue);
                  },
                ),
                SizedBox(height: _customSize_2),
                customText("Installment"),
                SizedBox(height: _customSize_1),
                CustomDropDown<int>(
                  hint: "Loan Duration",
                  btnBorderRadius: btnBorderRadius,
                  safeAreaC: safeAreaC,
                  items: widget.installments.map((item) {
                    return DropdownMenuItem<int>(
                      value: item.id.toInt(),

                      child: Text(item.value.toString()),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Please select duration";
                    }
                    return null;
                  },
                  onChanged: (int? newValue) {
                    InstallmentsModel selectedItem = widget.installments
                        .firstWhere((item) => item.id == newValue!.toDouble());
                    print(selectedItem.id);
                    print(selectedItem.value);
                  },
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
                  CustomRow(label: "Full Name", value: name.text),
                  Row(
                    children: [
                      Expanded(
                        child: CustomRow(label: "NIC Number", value: nic.text),
                      ),
                      Expanded(
                        child: CustomRow(
                          label: "Phone",
                          value: phoneNumber.text,
                        ),
                      ),
                    ],
                  ),
                  CustomRow(label: "Email", value: email.text),
                  CustomRow(label: "Permanent Address", value: address.text),
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
            padding: const EdgeInsets.only(right: 15),
            child: ValueListenableBuilder<bool>(
              valueListenable: CheckConnection.isOnline,
              builder: (context, online, child) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      CheckConnection.initialize();
                    });
                    showTopNotification(
                      context,
                      online ? "Device is Online" : "Device is Offline",
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: online
                          ? const Color.fromARGB(40, 9, 172, 58)
                          : const Color.fromARGB(40, 172, 9, 9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: online
                            ? const Color.fromARGB(255, 9, 172, 58)
                            : const Color.fromARGB(255, 172, 9, 9),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      online ? "ONLINE" : "OFFLINE",
                      style: TextStyle(
                        color: online
                            ? const Color.fromARGB(255, 9, 172, 58)
                            : const Color.fromARGB(255, 172, 9, 9),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
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
                        _currentStep == getSt.length - 1 ? "Submit" : "Next",
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

  Text customText(String lable_) {
    return Text(
      lable_.toUpperCase(),
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(138, 26, 26, 26),
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
}
