// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/view_model/user_view_model.dart';
import 'package:nkrs_app/models/Interest_rate_model.dart';
import 'package:nkrs_app/models/installment_model.dart';
import 'package:nkrs_app/models/new_customer_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/loan_request_section/loan_details_step.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/loan_request_section/personal_details_step.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/loan_request_section/summary_step.dart';
import 'package:nkrs_app/views/new_loan_request_view/new_loan_request/new_client_loan_request_status.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_app_bar.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/loading_dialog.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/navigator_back.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/successfull_message_view.dart';

class NewClientLoanRequest extends StatefulWidget {
  final List<InstallmentModel> installments;
  final List<InterestRateModel>? interestRates;
  const NewClientLoanRequest({
    super.key,
    required this.installments,
    this.interestRates,
  });

  @override
  State<NewClientLoanRequest> createState() => _NewClientLoanRequest();
}

class _NewClientLoanRequest extends State<NewClientLoanRequest> {
  int _currentStep = 0;
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _nic = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _loanAmount = TextEditingController();
  final TextEditingController _installment = TextEditingController();

  void _nextStep() {
    if (_currentStep == 0) {
      if (_step1Key.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      if (_step2Key.currentState!.validate()) {
        setState(() => _currentStep = 2);
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  Future<void> _submitForm() async {
    LoadingDialog.show(context, message: 'Please Wait...');
    final bool success = await UserViewModel().newCustomer(
      NewCustomerModel(
        customerId: int.parse(_nic.text),
        name: _name.text,
        address: _address.text,
        email: _email.text,
        phoneNumber: _phoneNumber.text,
        amount: double.parse(_loanAmount.text),
        installmentId: int.parse(_installment.text),
        employeeId: 1,
      ),
      context,
    );
    if (!context.mounted) return;
    LoadingDialog.hide(context);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoanSuccessScreen(
            bottomNavigatorBackButton: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanRequestSection(),
                ),
                (route) => false,
              );
            },
            bottomNavigatorViewButton: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewClientLoanRequestStatus(),
                ),
                (route) => false,
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: safeAreaC,
      appBar: CustomAppBar(
        title: "Existing Customer Loan",
        onBackPressed: () {
          NavigatorBack.customPopUpBox(
            context,
            destination: LoanRequestSection(),
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: safeAreaHorizontalPD,
            vertical: safeAreaVerticalPD - 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: appBarC,
              borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
              boxShadow: [MainCard.customShadow()],
            ),
            child: Column(
              children: [
                _buildProgressBar(),
                Expanded(
                  child: SingleChildScrollView(child: _buildCurrentStep()),
                ),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return Form(
          key: _step1Key,
          child: PersonalDetailsStep(
            address: _address,
            email: _email,
            name: _name,
            nic: _nic,
            phoneNumber: _phoneNumber,
          ),
        );
      case 1:
        return Form(
          key: _step2Key,
          child: LoanRequestSectionView(
            installments: widget.installments,
            loanAmount: _loanAmount,
            installment: _installment,
          ),
        );
      case 2:
        return SummaryStep(
          address: _address.text,
          email: _email.text,
          name: _name.text,
          nic: _nic.text,
          phoneNumber: _phoneNumber.text,
          amount: double.parse(_loanAmount.text).toStringAsFixed(2),
          installment: 60.toString(),
          type: "Day",
        );
      default:
        return Container();
    }
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: const Color.fromARGB(32, 55, 55, 55)),
        boxShadow: [
          BoxShadow(
            color: boxShadowC.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _stepNode(0, 'Customer', _currentStep >= 0),
          _lineIndicator(_currentStep >= 1),
          _stepNode(1, 'Loan Info', _currentStep >= 1),
          _lineIndicator(_currentStep >= 2),
          _stepNode(2, 'Summary', _currentStep >= 2),
        ],
      ),
    );
  }

  Widget _lineIndicator(bool active) {
    return Expanded(
      child: Container(
        height: active ? 2 : 0,
        color: active
            ? const Color.fromARGB(113, 33, 149, 243)
            : Colors.grey[200],
      ),
    );
  }

  Widget _stepNode(int step, String label, bool active) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? Colors.blue : Colors.white,
            border: Border.all(color: active ? Colors.blue : Colors.grey[300]!),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: active && _currentStep > step
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: active ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? Colors.blue : Colors.grey,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _currentStep == 2 ? _submitForm : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentStep == 2 ? 'Submit Application' : 'Next Step',
              ),
            ),
          ),
        ],
      ),
    );
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
}