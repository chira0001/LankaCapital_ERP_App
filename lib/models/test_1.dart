// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class NicUploadPage extends StatefulWidget {
//   const NicUploadPage({super.key});

//   @override
//   State<NicUploadPage> createState() => _NicUploadPageState();
// }

// class _NicUploadPageState extends State<NicUploadPage> {
//   File? nicFront;
//   File? nicBack;

//   // final ImagePicker picker = ImagePicker();

//   // Future<void> pickImage(bool isFront) async {
//   //   final XFile? image =
//   //       await picker.pickImage(source: ImageSource.gallery);

//   //   if (image != null) {
//   //     setState(() {
//   //       if (isFront) {
//   //         nicFront = File(image.path);
//   //       } else {
//   //         nicBack = File(image.path);
//   //       }
//   //     });
//   //   }
//   // }


//   Widget buildUploadBox(String title, File? image, bool isFront) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//         const SizedBox(height: 8),

//         GestureDetector(
//           // onTap: () => pickImage(isFront),
//           child: Container(
//             height: 130,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5F5F5),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade400),
//             ),
//             child: image == null
//                 ? const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.upload, size: 30),
//                       SizedBox(height: 5),
//                       Text("Tap to upload"),
//                     ],
//                   )
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.file(
//                       image,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     ),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F3F3),

//       appBar: AppBar(
//         title: const Text("New Client Loan Request"),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.blue,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// Step Indicator
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 circleStep("1", false),
//                 line(),
//                 circleStep("2", true),
//                 line(),
//                 circleStep("3", false),
//               ],
//             ),

//             const SizedBox(height: 20),


//             /// Card
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 8,
//                     color: Colors.black12,
//                   )
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: const [
//                       Icon(Icons.credit_card, color: Colors.blue),
//                       SizedBox(width: 8),
//                       Text(
//                         "NIC Details",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )
//                     ],
//                   ),

//                   const SizedBox(height: 15),


//                   buildUploadBox("NIC Front Side", nicFront, true),
//                   const SizedBox(height: 15),
//                   buildUploadBox("NIC Back Side", nicBack, false),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // validation here
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   "Next",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget circleStep(String text, bool active) {
//     return CircleAvatar(
//       radius: 14,
//       backgroundColor: active ? Colors.blue : Colors.grey.shade400,
//       child: Text(text, style: const TextStyle(color: Colors.white)),
//     );
//   }


//   Widget line() {
//     return Container(
//       width: 50,
//       height: 2,
//       color: Colors.grey,
//     );
//   }
// }