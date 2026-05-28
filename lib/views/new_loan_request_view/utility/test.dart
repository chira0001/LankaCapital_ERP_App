import 'package:flutter/material.dart';

class ManualExpandableContainer extends StatefulWidget {
  const ManualExpandableContainer({super.key});

  @override
  State<ManualExpandableContainer> createState() =>
      _ManualExpandableContainerState();
}

class _ManualExpandableContainerState extends State<ManualExpandableContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueAccent.shade400, Colors.indigo.shade700],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Allows container to shrink-wrap its contents
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Always Visible Header Text Block
          const Text(
            "Analytics Dashboard",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap the button below to see more.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),

          // Smoothly crossfades between nothing and the expanded content block
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild:
                const SizedBox.shrink(), // Takes zero space when collapsed
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.2)),
                const SizedBox(height: 16),
                Text(
                  "Your workspace traffic increased by 24% this week. Keep up the momentum to hit your next milestone!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),

          const SizedBox(height: 20),

          // The dedicated "Show More / Less" Action Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.indigo.shade900,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              // Conditional icon based on the expanded state
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 20,
              ),
              // Conditional text string based on state
              label: Text(
                _isExpanded ? "Show Less" : "Show More",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class CustomAppBar extends StatelessWidget
//     implements PreferredSizeWidget {
//   final String title;
//   final double logoSize;
//   final Color appBarColor;
//   final Color shadowColor;
//   final Color textColor;
//   final double fontSize;
//   final Widget navigatePage;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     required this.logoSize,
//     required this.appBarColor,
//     required this.shadowColor,
//     required this.textColor,
//     required this.fontSize,
//     required this.navigatePage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Row(
//         children: [
//           Image.asset(
//             'assets/images/logo/logo_1.png',
//             width: logoSize,
//             height: logoSize,
//             fit: BoxFit.cover,
//           ),
//           const SizedBox(width: 10),
//           Text(title),
//         ],
//       ),
//       centerTitle: true,
//       backgroundColor: appBarColor,
//       elevation: 2.0,
//       shadowColor: shadowColor,

//       leading: IconButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => navigatePage,
//             ),
//           );
//         },
//         icon: const Icon(
//           Icons.arrow_back_ios,
//           color: Colors.black,
//           size: 20,
//         ),
//       ),

//       titleTextStyle: TextStyle(
//         color: textColor,
//         fontSize: fontSize,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 1.3,
//       ),

//       actions: [
//         Padding(
//           padding: const EdgeInsets.only(right: 15),
//           child: ValueListenableBuilder<bool>(
//             valueListenable: CheckConnection.isOnline,
//             builder: (context, online, child) {
//               return GestureDetector(
//                 onTap: () {
//                   CheckConnection.initialize();

//                   if (online) {
//                     AppTopSnackBar.success(
//                       context,
//                       "Device is Online.",
//                       showClose: false,
//                       duration: const Duration(seconds: 2),
//                     );
//                   } else {
//                     AppTopSnackBar.error(
//                       context,
//                       "Device is Offline.",
//                       showClose: false,
//                       duration: const Duration(seconds: 2),
//                     );
//                   }
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     color: online
//                         ? const Color.fromARGB(40, 9, 172, 58)
//                         : const Color.fromARGB(40, 172, 9, 9),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: online
//                           ? const Color.fromARGB(255, 9, 172, 58)
//                           : const Color.fromARGB(255, 172, 9, 9),
//                       width: 0.5,
//                     ),
//                   ),
//                   child: Text(
//                     online ? "ONLINE" : "OFFLINE",
//                     style: TextStyle(
//                       color: online
//                           ? const Color.fromARGB(255, 9, 172, 58)
//                           : const Color.fromARGB(255, 172, 9, 9),
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
