import 'package:flutter/material.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/sync_view/connection_view.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarC,
      elevation: 2.0,
      shadowColor: appBarShadow,
      leading: IconButton(
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        icon: Icon(
            Icons.arrow_back_ios,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 20,
            fontWeight: FontWeight.w900,
          ),
      ),
      title: Text(title),
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
                  ConnectionView.show(context);
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}