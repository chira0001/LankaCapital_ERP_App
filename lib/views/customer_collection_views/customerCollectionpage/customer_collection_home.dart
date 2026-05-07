import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/collection_entry.dart';
import 'package:nkrs_app/views/customer_collection_views/profile/profile.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/main_card.dart';
import 'package:nkrs_app/views/new_loan_request_view/loan_request_section_view.dart';

class CustomerCollectionHome extends StatefulWidget {
  const CustomerCollectionHome({super.key});

  @override
  State<CustomerCollectionHome> createState() => _CustomerCollectionHomeState();
}

class _CustomerCollectionHomeState extends State<CustomerCollectionHome> {
  // int _selectedIndex = 0;
  // double logoSize = 32;
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
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
                // Greeting
                const Text(
                  "Hello, ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: kTinySpacing),
                const Text(
                  "Manage your daily collections and loan requests.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 20),

                // Cards
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectionEntryPage(),
                      ),
                    );
                  },
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanRequestSection(),
                      ),
                    );
                  },
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

                MainCard(
                  header: "Add printer",
                  description: "Add New Thermal printer or Existing one.",
                  cusIconRight: Icons.print,
                  iconColor: Colors.indigoAccent,
                  // ignore: deprecated_member_use
                  iconBackgrouundColor: Colors.indigoAccent.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
