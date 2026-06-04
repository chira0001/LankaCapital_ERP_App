// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nkrs_app/data/view_model/async_controller_view_model.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/data/view_model/sync_controller_view_model.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/custom_app_bar.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/loading_dialog.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/main_card.dart'
    show MainCard;

class SyncAsyncView extends StatefulWidget {
  final Map<String, dynamic>? syncTime;

  const SyncAsyncView({super.key, this.syncTime});

  @override
  State<SyncAsyncView> createState() => _SyncAsyncViewState();
}

class _SyncAsyncViewState extends State<SyncAsyncView> {
  @override
  void initState() {
    super.initState();
    CheckConnection.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Sync Setting",
        onBackPressed: () => Navigator.pop(context),
      ),
      backgroundColor: safeAreaC,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: safeAreaHorizontalPD,
              vertical: safeAreaVerticalPD,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appBarC,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.sync,
                            color: Color.fromARGB(255, 48, 45, 45),
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Database Sync",
                            style: TextStyle(
                              fontWeight: FontWeight(HeaderFW),
                              fontSize: headerFontSize,
                              color: headerTextC,
                              // letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Divider(
                        color: const Color.fromARGB(40, 51, 51, 51),
                        thickness: 1.5,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(Iconsax.timer_start_copy, color: btnC),
                                  SizedBox(width: 10),
                                  Text(
                                    "Last Sync   :",
                                    style: const TextStyle(
                                      color: Color.fromARGB(187, 48, 48, 48),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.syncTime?['last_sync'] != null
                                  ? DateFormat('dd/MM  hh:mm a').format(
                                      DateTime.parse(
                                        widget.syncTime!['last_sync'],
                                      ),
                                    )
                                  : 'Not Synced',
                              style: TextStyle(
                                color: Color(0xFF1A3D81),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(Iconsax.timer_pause_copy, color: btnC),
                                  SizedBox(width: 10),
                                  Text(
                                    "Last Async :",
                                    style: const TextStyle(
                                      color: Color.fromARGB(187, 48, 48, 48),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.syncTime?['last_async'] != null
                                  ? DateFormat('dd/MM  hh:mm a').format(
                                      DateTime.parse(
                                        widget.syncTime!['last_async'],
                                      ),
                                    )
                                  : 'Not Synced',
                              style: TextStyle(
                                color: Color(0xFF1A3D81),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: const Color.fromARGB(40, 51, 51, 51),
                        thickness: 1.5,
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          // if(){}
                          LoadingDialog.show(
                            context,
                            message: 'Please Wait...',
                          );
                          await SyncControllerViewModel().syncController(
                            context,
                          );
                          if (!context.mounted) return;
                          LoadingDialog.hide(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: appBarC,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(36, 93, 93, 93),
                            ),
                            boxShadow: [MainCard.customShadow()],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.cloud_download, color: btnC),
                              const SizedBox(width: 12),
                              Expanded(child: Text("Sync", style: _style())),
                              Icon(
                                Iconsax.arrow_right_3_copy,
                                size: 18,
                                color: const Color.fromARGB(201, 0, 0, 0),
                                fontWeight: FontWeight(700),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          LoadingDialog.show(
                            context,
                            message: 'Please Wait...',
                          );
                          await AsyncControllerViewModel().asyncController(
                            context,
                          );
                          if (!context.mounted) return;
                          LoadingDialog.hide(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: appBarC,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(36, 93, 93, 93),
                            ),
                            boxShadow: [MainCard.customShadow()],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.cloud_upload, color: btnC),
                              const SizedBox(width: 12),
                              Expanded(child: Text("Async", style: _style())),
                              Icon(
                                Iconsax.arrow_right_3_copy,
                                size: 18,
                                color: const Color.fromARGB(201, 0, 0, 0),
                                fontWeight: FontWeight(700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _style() {
    return TextStyle(
      color: headerTextC,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    );
  }
}
