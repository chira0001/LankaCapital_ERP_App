import 'package:flutter/material.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/collection_entry.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/main_card.dart';

class CustomerCollectionHome extends StatefulWidget {
  const CustomerCollectionHome({super.key});

  @override
  State<CustomerCollectionHome> createState() => _CustomerCollectionHomeState();
}

class _CustomerCollectionHomeState extends State<CustomerCollectionHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(height: kSmallSpacing),

                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(kContainerPadding),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(
                              kBorderRadiusSmall,
                            ),
                          ),
                          child: const Icon(
                            Icons.account_balance,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: kSmallSpacing),
                        const Text(
                          "Lanka Capital",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 23,
                      backgroundImage: AssetImage("assets/avatar.png"),
                    ),
                  ],
                ),

                SizedBox(height: kMediumSpacing),

                // Greeting
                const Text(
                  "Hello, Alex",
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

                MainCard(
                  header: "New Loan Request",
                  description:
                      "Submit a fresh loan application for a new or existing customer.",
                  cusIconRight: Icons.post_add,
                  iconColor: Colors.orange,
                  // ignore: deprecated_member_use
                  iconBackgrouundColor: Colors.orange.withOpacity(0.1),
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
