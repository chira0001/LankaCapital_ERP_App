import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nkrs_app/data/view_model/loan_view_model.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';
import 'package:nkrs_app/data/services/auth_service.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/receipt_preview_page.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/customer_collection_home.dart';
import 'package:nkrs_app/views/customer_collection_views/profile/profile.dart';
import 'package:nkrs_app/views/customer_collection_views/utility/dialog_box.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/data/services/database_service.dart';

class CollectionEntryPage extends StatefulWidget {
  const CollectionEntryPage({super.key});

  @override
  State<CollectionEntryPage> createState() => _CollectionEntryPageState();
}

class _CollectionEntryPageState extends State<CollectionEntryPage> {
  String todayDate = DateTime.now().toString().split(' ')[0];
  final TextEditingController nicController = TextEditingController();
  final TextEditingController lorncontroller = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final AuthService _authService = AuthService();
  LoanViewModel loanData = LoanViewModel();

  bool _isLoading = false;
  String? _errorMessage;
  User? _customer;
  List<Loan> _loans = [];
  Loan? _selectedLoan;
  double _calculatedPremium = 0.0;
  double _dueAmount = 0.0;

  List<Map<String, dynamic>> _todayCollections = [];
  int _todayEntries = 0;
  double _todayTotal = 0.0;

  // Daily task tracking
  String _currentUserName = "";
  String _officerRegion = "";
  double _dailyTarget = 0.0;

  @override
  void initState() {
    super.initState();
    paidAmountController.addListener(_calculateDueAmount);
    _loadTodayCollections();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final profile = await _authService.getCustomerProfile();
      if (profile != null && mounted) {
        final firstName = profile['firstName'] ?? '';
        final lastName = profile['lastName'] ?? '';
        final fullName = "$firstName $lastName".trim();
        final email = profile['email'] ?? '';
        final empId = profile['id'];

        setState(() {
          _currentUserName = fullName.isNotEmpty ? fullName : email;
        });

        // Fetch daily target using employee ID
        if (empId != null) {
          final targetData = await _authService.getDailyTarget(empId);
          if (targetData != null && mounted) {
            final rawTarget = targetData['amount'] ?? 0;
            final parsedTarget = (rawTarget is num)
                ? rawTarget.toDouble()
                : double.tryParse(rawTarget.toString()) ?? 0.0;
            final region = (targetData['region'] as String? ?? '').trim();

            setState(() {
              _dailyTarget = parsedTarget;
              if (region.isNotEmpty) {
                _officerRegion = region;
              } else {
                // Fallback to profile address if region in target is empty
                final profileAddress = (profile['address'] as String? ?? '').trim();
                _officerRegion = profileAddress.isNotEmpty ? profileAddress : 'All Regions';
              }
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile for task: $e');
    }
  }

  Future<void> _loadTodayCollections() async {
    final collections = await DatabaseService().getTodayCollections();
    double total = 0.0;
    for (var col in collections) {
      total += (col['paid_amount'] as num).toDouble();
    }
    setState(() {
      _todayCollections = collections;
      _todayEntries = collections.length;
      _todayTotal = total;
    });
  }

  void _calculateDueAmount() {
    if (_selectedLoan == null) return;

    double paidAmount = double.tryParse(paidAmountController.text) ?? 0.0;
    setState(() {
      _dueAmount = _calculatedPremium - paidAmount;
    });
  }

  void _handleLoanSelected(Loan loan) {
    setState(() {
      _selectedLoan = loan;
      double amount = loan.amount;
      double interest = amount * (loan.interestRate / 100);
      double docCharge = loan.documentCharge;
      int installments = loan.noOfInstallments;

      double totalPayable = amount + interest + docCharge;
      if (installments > 0) {
        _calculatedPremium = totalPayable / installments;
      } else {
        _calculatedPremium = totalPayable;
      }

      loanAmountController.text = _calculatedPremium.toStringAsFixed(2);
      _calculateDueAmount();
    });
  }

  @override
  void dispose() {
    nicController.dispose();
    lorncontroller.dispose();
    loanAmountController.dispose();
    paidAmountController.dispose();
    super.dispose();
  }

  Future<void> _findCustomerByNic() async {
    final nicText = nicController.text.trim();
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
      await loanData.searchByNic(nic);

      final loans = await loanData.getLoansByID();

      setState(() {
        _customer = loanData.user;
        _loans = loans;
        _isLoading = false;
      });

      if (_customer == null) {
        setState(() => _errorMessage = 'No customer found for this NIC.');
      } else if (loans.isEmpty) {
        setState(() => _errorMessage = 'No loans found for this customer.');
      } else {
        if (mounted) {
          DialogBox(
            loans: _loans,
            nicController: nicController,
            lorncontroller: lorncontroller,
            onLoanSelected: _handleLoanSelected,
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

  void _showLoanDialog() {
    if (_loans.isEmpty) {
      setState(
        () => _errorMessage = 'Please search by NIC first to load loans.',
      );
      return;
    }
    DialogBox(
      loans: _loans,
      nicController: nicController,
      lorncontroller: lorncontroller,
      onLoanSelected: _handleLoanSelected,
    ).showLoanDialog(context);
  }

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
                    "$todayDate  • Session Active",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: CheckConnection.isOnline,
                    builder: (context, isOnline, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kSmallSpacing,
                          vertical: kExtraSmallSpacing,
                        ),
                        decoration: BoxDecoration(
                          color: isOnline
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(
                            kBorderRadiusExtraLarge,
                          ),
                        ),
                        child: Text(
                          isOnline ? "● ONLINE" : "● OFFLINE",
                          style: TextStyle(
                            color: isOnline ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
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
                            controller: nicController,
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
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.green,
                          ),
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
                          const Icon(
                            Icons.error_outline,
                            size: 14,
                            color: Colors.red,
                          ),
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
                      "LORN AMOUNT",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: kTinySpacing),
                    _amountField(
                      highlight: false,
                      controller: loanAmountController,
                      readOnly: true,
                      hint: "Calculated Premium Amount",
                    ),

                    const SizedBox(height: kSectionSpacing),

                    const Text(
                      "PAID AMOUNT",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                    const SizedBox(height: kTinySpacing),
                    _amountField(
                      highlight: true,
                      controller: paidAmountController,
                      readOnly: false,
                      hint: "Enter Paid Amount",
                    ),

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "BALANCE DUE",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: kXSmallSpacing),
                          Text(
                            "${_dueAmount.toStringAsFixed(2)} LKR",
                            style: const TextStyle(
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

                        onPressed: () async {
                          if (_selectedLoan == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a loan first.'),
                              ),
                            );
                            return;
                          }

                          final paidAmountText = paidAmountController.text;
                          if (paidAmountText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter the paid amount.'),
                              ),
                            );
                            return;
                          }

                          double paidAmount =
                              double.tryParse(paidAmountText) ?? 0.0;
                          String receiptId = DateTime.now()
                              .millisecondsSinceEpoch
                              .toString();
                          String fileNumber = _selectedLoan!.fileNumber;
                          String collectedBy = _currentUserName;

                          try {
                            await DatabaseService().insertCollection(
                              receiptId: receiptId,
                              fileNumber: fileNumber,
                              premiumAmount: _calculatedPremium,
                              paidAmount: paidAmount,
                              dueAmount: _dueAmount,
                              collectedBy: collectedBy,
                            );

                            await _loadTodayCollections();

                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReceiptPreviewPage(
                                  receiptId: receiptId,
                                  fileNumber: fileNumber,
                                  premiumAmount: _calculatedPremium,
                                  paidAmount: paidAmount,
                                  dueAmount: _dueAmount,
                                  collectedBy: collectedBy,
                                  collectionDate: DateTime.now(),
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to save data: $e'),
                              ),
                            );
                          }
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

              // ── Summary row ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TODAY: $_todayEntries ENTRIES",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "TOTAL: ${_todayTotal.toStringAsFixed(2)} LKR",
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: kMediumSpacing),

              // ── Daily Task Dashboard ───────────────────────────────────
              _buildDailyTaskCard(),
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

              if (_todayCollections.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: kMediumSpacing),
                  child: Center(
                    child: Text(
                      "No collections today",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),

              ..._todayCollections.map((col) {
                final timeStr = col['collection_date'].toString();
                DateTime time = DateTime.tryParse(timeStr) ?? DateTime.now();
                String formattedTime =
                    "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                String title = "Loan #${col['file_number']}";
                String amount = (col['paid_amount'] as num).toStringAsFixed(2);
                return _recentItem(col, title, formattedTime, amount);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountField({
    required bool highlight,
    required TextEditingController controller,
    required bool readOnly,
    required String hint,
  }) {
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
              controller: controller,
              readOnly: readOnly,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
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

  Widget _recentItem(
    Map<String, dynamic> col,
    String title,
    String time,
    String amount,
  ) {
    return InkWell(
      onTap: () {
        final timeStr = col['collection_date'].toString();
        DateTime collectionTime = DateTime.tryParse(timeStr) ?? DateTime.now();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptPreviewPage(
              receiptId: col['receipt_id'] ?? "",
              fileNumber: col['file_number'] ?? "",
              premiumAmount: (col['premium_amount'] as num?)?.toDouble() ?? 0.0,
              paidAmount: (col['paid_amount'] as num?)?.toDouble() ?? 0.0,
              dueAmount: (col['due_amount'] as num?)?.toDouble() ?? 0.0,
              collectedBy: col['collected_by'] ?? "Unknown",
              collectionDate: collectionTime,
              isViewOnly: true,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(kBorderRadiusMedium),
      child: Container(
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
      ),
    );
  }

  Widget _buildDailyTaskCard() {
    final bool hasTarget = _dailyTarget > 0;
    final double collected = _todayTotal;
    final double remaining = hasTarget
        ? (_dailyTarget - collected).clamp(0, _dailyTarget)
        : 0;
    final double percentage = hasTarget
        ? (collected / _dailyTarget).clamp(0.0, 1.0)
        : 0.0;
    final int percentInt = (percentage * 100).round();

    // Colour logic: red < 30%, amber < 60%, green >= 60% (task accomplished)
    final Color progressColor = percentInt >= 100
        ? Colors.green.shade800
        : percentInt >= 60
            ? Colors.green.shade500
            : percentInt >= 30
                ? Colors.amber.shade700
                : Colors.red.shade500;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 44, 72, 116),
            const Color.fromARGB(255, 61, 63, 65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.blue.shade900.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "DAILY TASK",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  letterSpacing: 1.5,
                ),
              ),
              // Region badge
              if (_officerRegion.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 11,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _officerRegion,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Percentage + ring
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular progress indicator
              SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 6,
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.15),
                    ),
                    CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 6,
                      color: progressColor,
                      backgroundColor: Colors.transparent,
                    ),
                    Text(
                      "$percentInt%",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Amounts column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _taskAmountRow(
                      label: "TARGET",
                      value: hasTarget
                          ? "${_dailyTarget.toStringAsFixed(2)} LKR"
                          : "Not set",
                      color: Colors.white,
                      bold: true,
                    ),
                    const SizedBox(height: 6),
                    _taskAmountRow(
                      label: "COLLECTED",
                      value: "${collected.toStringAsFixed(2)} LKR",
                      color: Colors.greenAccent.shade200,
                      bold: false,
                    ),
                    const SizedBox(height: 6),
                    _taskAmountRow(
                      label: "REMAINING",
                      value: hasTarget
                          ? "${remaining.toStringAsFixed(2)} LKR"
                          : "—",
                      color: remaining > 0
                          ? Colors.orangeAccent.shade100
                          : Colors.greenAccent,
                      bold: false,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Linear progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              // ignore: deprecated_member_use
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$_todayEntries collection${_todayEntries == 1 ? '' : 's'} today",
                style: const TextStyle(fontSize: 10, color: Colors.white54),
              ),
              Text(
                hasTarget
                    ? (percentage >= 1.0
                        ? "🏆 Target reached!"
                        : percentage >= 0.6
                            ? "⭐ Task Accomplished!"
                            : "${(percentage * 100).toStringAsFixed(1)}% done")
                    : "No target assigned",
                style: TextStyle(
                  fontSize: 10,
                  color: percentage >= 1.0
                      ? Colors.greenAccent
                      : percentage >= 0.6
                          ? Colors.greenAccent.shade200
                          : Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taskAmountRow({
    required String label,
    required String value,
    required Color color,
    required bool bold,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white54,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
