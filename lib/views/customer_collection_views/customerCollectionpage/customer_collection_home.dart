import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/utility/navigation_helper.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/collection_entry.dart';
import 'package:nkrs_app/views/customer_collection_views/printer/add_printer_page.dart';
import 'package:nkrs_app/views/customer_collection_views/profile/profile.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';
import 'package:nkrs_app/data/services/auth_service.dart';
import 'package:nkrs_app/data/services/printer_service.dart';

class CustomerCollectionHome extends StatefulWidget {
  const CustomerCollectionHome({super.key});

  @override
  State<CustomerCollectionHome> createState() => _CustomerCollectionHomeState();
}

class _CustomerCollectionHomeState extends State<CustomerCollectionHome> {
  final AuthService _authService = AuthService();
  final PrinterService _printerService = PrinterService();
  String _userName = "Loading...";
  bool _printerConnected = false;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _checkPrinter();
  }

  void _fetchUserName() async {
    final name = await _authService.getUserName();
    if (mounted) {
      setState(() {
        _userName = name ?? "User";
      });
    }
  }

  Future<void> _checkPrinter() async {
    final saved = await _printerService.getSavedPrinter();
    if (!mounted) return;
    setState(() => _printerConnected = saved != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(kContainerPadding),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(kBorderRadiusSmall),
              ),
              child: const Icon(Icons.account_balance, color: Colors.white),
            ),
            SizedBox(width: 10),
            Text("Lanka Capital"),
          ],
        ),
        centerTitle: true,
        backgroundColor: appBarC,
        elevation: 2.0,
        shadowColor: appBarShadow,
        titleTextStyle: TextStyle(
          color: btnC,
          fontSize: appBarFontS,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3,
        ),
        actions: [
          IconButton(
            onPressed: () {
              NavigationHelper.push(context, const ProfilePage());
            },
            icon: Icon(
              Iconsax.user_edit_copy,
              color: Color.fromARGB(255, 0, 0, 0),
              size: appBarIconS,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: safeAreaHorizontalPD,
              vertical: safeAreaVerticalPD,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, $_userName",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: kTinySpacing),
                const Text(
                  "Manage your daily collections and loan requests.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 20),

                InkWell(
                  onTap: () => NavigationHelper.push(context, const CollectionEntryPage()),
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  child: MainCard(
                    header: "Customer Collection",
                    description:
                        "Add installment or view existing collection history for any borrower.",
                    cusIconRight: Icons.person_search,
                    iconColor: Colors.blue,
                    // ignore: deprecated_member_use
                    iconBackgrouundColor: Colors.blue.withOpacity(0.1),
                  ),
                ),
                SizedBox(height: kMediumSpacing),
                InkWell(
                  onTap: () => NavigationHelper.push(context, LoanRequestSection()),
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  child: MainCard(
                    header: "New Loan Request",
                    description:
                        "Submit a fresh loan application for a new or existing customer.",
                    cusIconRight: Icons.post_add,
                    iconColor: Colors.orange,
                    // ignore: deprecated_member_use
                    iconBackgrouundColor: Colors.orange.withOpacity(0.1),
                  ),
                ),

                SizedBox(height: kMediumSpacing),

                InkWell(
                  onTap: () async {
                    await NavigationHelper.push(context, const AddPrinterPage());
                    await _checkPrinter();
                  },
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  child: MainCard(
                    header: _printerConnected ? "Printer Connected" : "Add Printer",
                    description: _printerConnected
                        ? "Manage your connected Bluetooth thermal printer."
                        : "Search and connect a new Bluetooth thermal printer.",
                    cusIconRight: Icons.print,
                    iconColor: _printerConnected ? Colors.green : Colors.indigoAccent,
                    // ignore: deprecated_member_use
                    iconBackgrouundColor: (_printerConnected ? Colors.green : Colors.indigoAccent)
                        .withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
