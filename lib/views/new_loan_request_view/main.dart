// import 'package:flutter/material.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:nkrs_app/utility/constanst.dart';
// import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';

// // void main() {
// //   // runApp(const MyApp());
// // }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Color themeColor = Color(0xFF9151FD);
//   int _selectedIndex = 0;
//   double logoSize = 32;
//   final List<Widget> _pages = [
//     // HomePage(),
//     LoanRequestSection(),
//     Container(color: Colors.green),
//     Container(color: Colors.orange),
//     Container(color: Colors.purple),
//     Container(color: const Color.fromARGB(255, 215, 215, 215)),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Money Leading App",
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Image.asset(
//                 'assets/images/logo/logo_1.png',
//                 width: logoSize,
//                 height: logoSize,
//                 fit: BoxFit.cover,
//               ),
//               SizedBox(width: 10),
//               Text("Lanka Capital"),
//             ],
//           ),
//           centerTitle: true,
//           backgroundColor: appBarC,
//           elevation: 2.0,
//           shadowColor: appBarShadow,
//           leading: GestureDetector(
//             onTap: () {
//               // Navigator.pop(context);
//             },
//             child: IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: const Color.fromARGB(255, 0, 0, 0),
//                 size: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           titleTextStyle: TextStyle(
//             color: btnC,
//             fontSize: appBarFontS,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.3,
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Iconsax.notification_bing_copy,
//                 color: const Color.fromARGB(255, 0, 0, 0),
//                 size: appBarIconS,
//               ),
//             ),
//             const SizedBox(width: 12),
//           ],
//         ),

//         body: SafeArea(child: _pages[_selectedIndex]),

//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _selectedIndex = 4;
//             });
//           },
//           backgroundColor: btnC,
//           elevation: 0,
//           shape: CircleBorder(
//             // ignore: deprecated_member_use
//             side: BorderSide(color: btnC.withOpacity(0.1), width: 8),
//           ),
//           child: const Icon(Icons.add, color: Colors.white, size: 33),
//         ),

//         bottomNavigationBar: BottomAppBar(
//           color: const Color.fromARGB(255, 255, 255, 255),
//           elevation: 0,
//           notchMargin: 0,
//           shape: const CircularNotchedRectangle(),
//           // height: 75,
//           // notchMargin: ,
//           child: Container(
//             // color: const Color.fromARGB(255, 123, 123, 123),
//             margin: EdgeInsets.all(0),
//             height: 70,
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 // Left side
//                 _buildNavItem(
//                   0,
//                   Iconsax.home_2,
//                   Iconsax.home_2_copy,
//                   'Home',
//                   bottomBarIconC,
//                 ),
//                 _buildNavItem(
//                   1,
//                   Iconsax.search_normal,
//                   Iconsax.search_normal_1_copy,
//                   'Search',
//                   bottomBarIconC,
//                 ),
//                 const SizedBox(width: 30),
//                 // Right side
//                 _buildNavItem(
//                   2,
//                   Iconsax.timer_1,
//                   Iconsax.timer_1_copy,
//                   'History',
//                   bottomBarIconC,
//                 ),
//                 _buildNavItem(
//                   3,
//                   Iconsax.user,
//                   Iconsax.user_copy,
//                   'Profile',
//                   bottomBarIconC,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(
//     int index,
//     IconData iconSelected,
//     IconData iconNormal,
//     String label,
//     Color themeColor,
//   ) {
//     final bool isSelected = _selectedIndex == index;
//     final Color activeColor = themeColor;
//     final Color inactiveColor = const Color.fromARGB(137, 43, 43, 43);

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isSelected ? iconSelected : iconNormal,
//               size: isSelected ? bottomIconSizeA : bottomIconSizeDis,
//               color: isSelected ? activeColor : inactiveColor,
//             ),
//             isSelected
//                 ? Container(
//                     child: Text(
//                       label,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: isSelected ? activeColor : inactiveColor,
//                       ),
//                     ),
//                   )
//                 : Container(
//                     width: 0,
//                     height: 0,
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(
//                         0,
//                         125,
//                         0,
//                         0,
//                       ), // Or set to your dot color
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
