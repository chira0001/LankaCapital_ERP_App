import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';
import 'package:nkrs_app/services/auth_service.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/ReceiptPreviewPage.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/customer_collection_home.dart';
import 'package:nkrs_app/views/customer_collection_views/profile/profile.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/dialog_box.dart';

class CollectionEntryPage extends StatefulWidget {
  const CollectionEntryPage({super.key});

  @override
  State<CollectionEntryPage> createState() => _CollectionEntryPageState();
}

class _CollectionEntryPageState extends State<CollectionEntryPage> {
  final String _todayDate = DateTime.now().toString().split(' ')[0];
  final TextEditingController NICcontroller = TextEditingController();
  final TextEditingController lorncontroller = TextEditingController();
  final AuthService _authService = AuthService();


  bool _isLoading = false;
  String? _errorMessage;
  User? _customer;
  List<Loan> _loans = [];

  @override
  void dispose() {
    NICcontroller.dispose();
    lorncontroller.dispose();
    super.dispose();
  }

 
  Future<void> _findCustomerByNic() async {
    final nicText = NICcontroller.text.trim();
    if (nicText.isEmpty) {
      setState(() => _errorMessage = 'Please enter a NIC number first.');
      return;
    }

    final nic = int.tryParse(nicText);
    if (nic == null) {
      setState(() => _errorMessage = 'NIC must be a valid number.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _customer = null;
      _loans = [];
    });

    try {
      final (user, loans) = await _authService.fetchCustomerAndLoans(nic);
      setState(() {
        _customer = user;
        _loans = loans;
        _isLoading = false;
      });

      if (loans.isEmpty) {
        setState(() => _errorMessage = 'No loans found for this customer.');
      } else {
        // Show the loan selection dialog
        if (mounted) {
          DialogBox(
            loans: _loans,
            NICcontroller: NICcontroller,
            lorncontroller: lorncontroller,
          ).showLoanDialog(context);
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to fetch data: ${e.toString()}';
      });
    }
  }

  /// Called when the user taps FIND next to the Loan Number field.
  /// Opens the dialog directly if loans are already loaded.
  void _showLoanDialog() {
    if (_loans.isEmpty) {
      setState(() => _errorMessage = 'Please search by NIC first to load loans.');
      return;
    }
    DialogBox(
      loans: _loans,
      NICcontroller: NICcontroller,
      lorncontroller: lorncontroller,
    ).showLoanDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerCollectionHome()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 0, 0, 0),
            size: 20,
          ),
        ),
        leadingWidth: 17,
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
          padding: EdgeInsets.all(kCardPadding),
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
                  Text(
                    "$_todayDate • Session Active",
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
                    child: Text(
                      "scsss",

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
                      "# ENTER USER NIC",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: kXSmallSpacing),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: NICcontroller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Enter Customer NIC",
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
                        InkWell(
                          onTap: _isLoading ? null : _findCustomerByNic,
                          borderRadius: BorderRadius.circular(
                            kBorderRadiusMedium,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(kIconPadding),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(
                                kBorderRadiusMedium,
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "FIND",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                          ),
                        ),
                      ],
                    ),

                    // Customer name display
                    if (_customer != null) ...[
                      const SizedBox(height: kXSmallSpacing),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            _customer!.name,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Error message display
                    if (_errorMessage != null) ...[
                      const SizedBox(height: kXSmallSpacing),
                      Row(
                        children: [
                          const Icon(Icons.error_outline, size: 14, color: Colors.red),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: kSectionSpacing),

                    const Text(
                      "# LOAN NUMBER",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: kXSmallSpacing),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: lorncontroller,
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
                        InkWell(
                          onTap: _showLoanDialog,
                          borderRadius: BorderRadius.circular(
                            kBorderRadiusMedium,
                          ),
                          child: Container(
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
