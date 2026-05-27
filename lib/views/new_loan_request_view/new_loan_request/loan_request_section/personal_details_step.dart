// import 'package:flutter/material.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:nkrs_app/utility/constanst.dart';
// import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart'
//     show MainCard;

// class PersonalDetailsStep extends StatelessWidget {
//   PersonalDetailsStep({super.key});

//   final TextEditingController name = TextEditingController();
//   final TextEditingController nic = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController address = TextEditingController();
//   // final TextEditingController password = TextEditingController();
//   final TextEditingController phoneNumber = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 30),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: appBarC,
//         borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
//         boxShadow: [MainCard.customShadow()],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Icon(Iconsax.user, size: 30, color: btnC),
//               SizedBox(width: 10),
//               Text(
//                 "Personal Details",
//                 style: TextStyle(
//                   fontSize: cardHeaderFS,
//                   color: cardHeaderFC,
//                   fontWeight: FontWeight(700),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 30),
//           customText("Full Name"),
//           SizedBox(height: _customSize_1),
//           CustomTextField(
//             controllerNames: name,
//             labelText_: "John Doe",
//             validatorCallback: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Please enter your name";
//               } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//                 return "Name cannot contain only numbers or special characters";
//               } else {
//                 return null;
//               }
//             },
//             type: TextInputType.text,
//           ),
//           SizedBox(height: _customSize_2),
//           customText("Address"),
//           SizedBox(height: _customSize_1),
//           CustomTextField(
//             controllerNames: address,
//             labelText_: "No: 123, Street Name",
//             type: TextInputType.text,
//             validatorCallback: (value) {
//               return null;

//               // if (value == null || value.isEmpty) {
//               //   return "Please enter your address";
//               // } else if (value.length < 5) {
//               //   return "Please enter a valid address";
//               // } else {
//               //   return null;
//               // }
//             },
//           ),
//           SizedBox(height: _customSize_2),
//           customText("E-mail"),
//           SizedBox(height: _customSize_1),
//           CustomTextField(
//             controllerNames: email,
//             labelText_: "Example@email.com",
//             type: TextInputType.emailAddress,
//             validatorCallback: (value) {
//               return null;
//               // if (value == null || value.isEmpty) {
//               //   return "Please enter your email";
//               // } else if (!RegExp(
//               //   r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
//               // ).hasMatch(value)) {
//               //   return "Please enter a valid email address";
//               // } else {
//               //   return null;
//               // }
//             },
//           ),
//           SizedBox(height: _customSize_2),
//           customText("NIC Number"),
//           SizedBox(height: _customSize_1),
//           CustomTextField(
//             controllerNames: nic,
//             labelText_: "Enter NIC Number",
//             type: TextInputType.number,
//             validatorCallback: (value) {
//               return null;

//               // if (value == null || value.isEmpty) {
//               //   return "Please enter your NIC number";
//               // } else if (value.length < 8 && value.length > 15) {
//               //   return "Please enter a valid NIC number";
//               // } else {
//               //   return null;
//               // }
//             },
//           ),
//           SizedBox(height: _customSize_2),
//           customText("Phone Number"),
//           SizedBox(height: _customSize_1),
//           CustomTextField(
//             controllerNames: phoneNumber,
//             labelText_: "0712345678",
//             type: TextInputType.phone,
//             validatorCallback: (value) {
//               return null;

//               // if (value == null || value.isEmpty) {
//               //   return "Please enter your phone number";
//               // } else if (value.length != 10 || !value.startsWith('07')) {
//               //   return "Please enter a valid phone number";
//               // } else {
//               //   return null;
//               // }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
