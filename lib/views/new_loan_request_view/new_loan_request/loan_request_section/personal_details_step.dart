import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_text_field.dart';

class PersonalDetailsStep extends StatelessWidget {
  final TextEditingController _name;
  final TextEditingController _nic;
  final TextEditingController _email;
  final TextEditingController _address;
  final TextEditingController _phoneNumber;

  const PersonalDetailsStep({
    super.key,
    required TextEditingController name,
    required TextEditingController nic,
    required TextEditingController email,
    required TextEditingController address,
    required TextEditingController phoneNumber,
  }) : _phoneNumber = phoneNumber,
       _name = name,
       _nic = nic,
       _email = email,
       _address = address;

  static final double _customSize_1 = 4;
  static final double _customSize_2 = 25;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Personal Details",
                style: TextStyle(
                  fontSize: cardHeaderFS,
                  color: cardHeaderFC,
                  fontWeight: FontWeight(700),
                ),
              ),
              IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.info_outline_rounded,
                  size: 25,
                  color: const Color.fromARGB(94, 51, 51, 51),
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          customText("Full Name"),
          SizedBox(height: _customSize_1),
          CustomTextField(
            controllerNames: _name,
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
            controllerNames: _address,
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
            controllerNames: _email,
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
            controllerNames: _nic,
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
            controllerNames: _phoneNumber,
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
          // _buildActionButtons(),
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
