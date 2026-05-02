import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/ReceiptPreviewPage.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/customer_collection_home.dart';
import 'package:nkrs_app/views/customer_collection_views/profile/profile.dart';

class CollectionEntryPage extends StatelessWidget {
  const CollectionEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerCollectionHome()),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
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
              color: const Color.fromARGB(255, 0, 0, 0),
              size: appBarIconS,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      backgroundColor: safeAreaC,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kCardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "DAILY COLLECTION ENTRY",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: kTinySpacing),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "April #, 2026 • Session Active",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSmallSpacing,
                      vertical: kExtraSmallSpacing,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(
                        kBorderRadiusExtraLarge,
                      ),
                    ),
                    child: const Text(
                      "● SYNCED",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: kMediumSpacing),

              Container(
                padding: const EdgeInsets.all(kCardPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kBorderRadiusExtraLarge),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "# LOAN NUMBER",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: kXSmallSpacing),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter Loan #0000",
                              filled: true,
                              fillColor: const Color(0xFFF1F3F6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  kBorderRadiusMedium,
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: kSmallSpacing),
                        Container(
                          padding: const EdgeInsets.all(kIconPadding),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(
                              kBorderRadiusMedium,
                            ),
                          ),
                          child: const Text(
                            "FIND",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: kSectionSpacing),

                    const Text(
                      "PREMIUM AMOUNT",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: kTinySpacing),
                    _amountField(false),

                    const SizedBox(height: kSectionSpacing),

                    const Text(
                      "PAID AMOUNT",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                    const SizedBox(height: kTinySpacing),
                    _amountField(true),

                    const SizedBox(height: kSectionSpacing),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(kIconPadding),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(
                          kBorderRadiusMedium,
                        ),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BALANCE DUE",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          SizedBox(height: kXSmallSpacing),
                          Text(
                            "0 LKR",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "* Calculated based on current entry",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: kMediumSpacing),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              kBorderRadiusMedium,
                            ),
                          ),
                        ),

                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptPreviewPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "SUBMIT & PRINT",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: kMediumSpacing),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "TODAY: 0 ENTRIES",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "TOTAL: 0.00 LKR",
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: kMediumSpacing),

              const Text(
                "RECENT COLLECTIONS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: kSmallSpacing),

              _recentItem("#1 - John Doe", "2 hours ago", "40.00"),
            ],
          ),
        ),
      ),
    );
  }

  // FIXED AMOUNT FIELD (with proper hint text)
  Widget _amountField(bool highlight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kIconPadding),
      decoration: BoxDecoration(
        color: highlight ? Colors.green.shade50 : const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(kBorderRadiusMedium),
        border: highlight
            ? Border.all(color: Colors.green)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: highlight
                    ? "Enter Paid Amount"
                    : "Enter Premium Amount",
              ),
            ),
          ),
          Text(
            "LKR",
            style: TextStyle(color: highlight ? Colors.green : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _recentItem(String title, String time, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSmallSpacing),
      padding: const EdgeInsets.all(kIconPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadiusMedium),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "LKR",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
