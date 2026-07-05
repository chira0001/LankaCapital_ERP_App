import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_user_service.dart';
import 'package:nkrs_app/data/view_model/collection_view_model.dart';
import 'package:nkrs_app/models/collections_model.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/collection_entry.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/payment_complete_screen.dart'
    show PaymentCompleteScreen;

class ReceiptPreviewPage extends StatelessWidget {
  final String receiptId;
  final String fileNumber;
  final double premiumAmount;
  final double paidAmount;
  final double dueAmount;
  final String collectedBy;
  final DateTime collectionDate;
  final bool isViewOnly;

  const ReceiptPreviewPage({
    super.key,
    required this.receiptId,
    required this.fileNumber,
    required this.premiumAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.collectedBy,
    required this.collectionDate,
    this.isViewOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Icons.arrow_back_ios;
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        centerTitle: true,
        title: const Text(
          "Receipt Preview",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// RECEIPT CARD
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "NKRS LANKA CAPITAL (PVT) LTD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Collection Receipt",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    _row("Receipt ID:", receiptId),
                    _row(
                      "Collection Date:",
                      "${collectionDate.year}-${collectionDate.month.toString().padLeft(2, '0')}-${collectionDate.day.toString().padLeft(2, '0')}",
                    ),
                    _row(
                      "Print Date & Time:",
                      "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                    ),

                    const Divider(height: 25),

                    _row("Loan Number:", fileNumber),

                    const Divider(height: 25),

                    _row(
                      "Premium Amount:",
                      "LKR ${premiumAmount.toStringAsFixed(2)}",
                    ),
                    _rowBold(
                      "Paid Amount:",
                      "LKR ${paidAmount.toStringAsFixed(2)}",
                    ),
                    _row("Due Amount:", "LKR ${dueAmount.toStringAsFixed(2)}"),

                    const Divider(height: 25),

                    _row("Collected By:", collectedBy),

                    const Spacer(),

                    const Text(
                      "This is a provisional receipt. Subject to realization.",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTONS
            if (!isViewOnly)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CollectionEntryPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.print, color: Colors.red),
                      label: const Text(
                        "Re-print",
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        int? c = await DatabaseUserService().getTempUserId();
                        CollectionViewModel().addCollection(
                          CollectionsModel(
                            dueAmount: dueAmount,
                            fileNumber: fileNumber,
                            installmentNumber: c!,
                            paidAmount: paidAmount,
                            employeeId: 1,
                          ),
                          context,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentCompleteScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.print, color: Colors.white),
                      label: const Text(
                        "Print Receipt",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }

  Widget _rowBold(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
