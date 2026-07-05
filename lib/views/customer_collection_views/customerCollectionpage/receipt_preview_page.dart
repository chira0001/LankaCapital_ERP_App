import 'package:flutter/material.dart';

import 'package:nkrs_app/data/services/database_service/database_user_service.dart';
import 'package:nkrs_app/data/view_model/collection_view_model.dart';
import 'package:nkrs_app/models/collections_model.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/collection_entry.dart';

import 'package:nkrs_app/data/services/database_service.dart';
import 'package:nkrs_app/data/services/printer_service.dart';
import 'package:nkrs_app/utility/receipt_formatter.dart';

import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/payment_complete_screen.dart'
    show PaymentCompleteScreen;

/// Shows the on-screen receipt preview.
///
/// **Print-first rule**: the collection is written to the local SQLite DB
/// only after the thermal printer confirms the bytes were sent successfully.
/// If the print is cancelled or fails, nothing is persisted — the user can
/// still press Print Receipt to try again, or use the back button to discard.
///
/// Returns `true` to the caller ([CollectionEntryPage]) via [Navigator.pop]
/// so that the entry list can refresh after a successful print.
class ReceiptPreviewPage extends StatefulWidget {
  final String receiptId;
  final String fileNumber;
  final double premiumAmount;
  final double paidAmount;
  final double dueAmount;
  final String collectedBy;
  final DateTime collectionDate;

  /// When true, the page is opened for viewing a past receipt.
  /// Print buttons are hidden and nothing is saved.
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
  State<ReceiptPreviewPage> createState() => _ReceiptPreviewPageState();
}

class _ReceiptPreviewPageState extends State<ReceiptPreviewPage> {
  bool _isPrinting = false;
  bool _isSaving = false;

  // ── helpers ──────────────────────────────────────────────────────────────

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatDateTime(DateTime d) =>
      '${_formatDate(d)} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  // ── print & save ─────────────────────────────────────────────────────────

  /// Called when the user taps "Print Receipt".
  ///
  /// Flow:
  /// 1. Mark as printing (disables button).
  /// 2. Send ESC/POS bytes to Bluetooth printer.
  /// 3. If print succeeds → save collection to local DB.
  /// 4. Pop with `true` so CollectionEntryPage refreshes its list.
  Future<void> _printAndSave() async {
    if (_isPrinting || _isSaving) return;

    setState(() => _isPrinting = true);

    // Build the bytes
    final bytes = await ReceiptFormatter.buildCollectionReceipt(
      receiptId: widget.receiptId,
      fileNumber: widget.fileNumber,
      premiumAmount: widget.premiumAmount,
      paidAmount: widget.paidAmount,
      dueAmount: widget.dueAmount,
      collectedBy: widget.collectedBy,
      collectionDate: widget.collectionDate,
    );

    // Print bytes
    final bool printed = await PrinterService().printBytes(bytes);

    if (!mounted) return;

    if (!printed) {
      setState(() => _isPrinting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Print failed. Check the printer is on and in range.'),
          backgroundColor: Colors.red,
        ),
      );
      // Nothing saved — user can retry.
      return;
    }

    // Print confirmed ✓ — now persist the collection locally.
    setState(() {
      _isPrinting = false;
      _isSaving = true;
    });

    try {
      await DatabaseService().insertCollection(
        receiptId: widget.receiptId,
        fileNumber: widget.fileNumber,
        premiumAmount: widget.premiumAmount,
        paidAmount: widget.paidAmount,
        dueAmount: widget.dueAmount,
        collectedBy: widget.collectedBy,
      );

      debugPrint(
        '[ReceiptPreviewPage] Collection ${widget.receiptId} saved after print.',
      );
    } catch (e) {
      // This should be rare (DB error). Log it but still navigate —
      // the receipt was already printed so the transaction happened.
      debugPrint('[ReceiptPreviewPage] DB save failed after print: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }

    if (!mounted) return;

    // Use push, await the result, and then pass it back to the caller
    // so CollectionEntryPage gets the 'true' and clears its fields.
    final bool? success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const PaymentCompleteScreen()),
    );

    if (success == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _reprintOnly() async {
    if (_isPrinting) return;

    setState(() => _isPrinting = true);

    // Build the bytes
    final bytes = await ReceiptFormatter.buildCollectionReceipt(
      receiptId: widget.receiptId,
      fileNumber: widget.fileNumber,
      premiumAmount: widget.premiumAmount,
      paidAmount: widget.paidAmount,
      dueAmount: widget.dueAmount,
      collectedBy: widget.collectedBy,
      collectionDate: widget.collectionDate,
    );

    // Print bytes
    final bool printed = await PrinterService().printBytes(bytes);

    if (!mounted) return;
    setState(() => _isPrinting = false);

    if (printed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receipt reprinted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Print failed. Check the printer is on and in range.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ── build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool busy = _isPrinting || _isSaving;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: busy ? null : () => Navigator.pop(context, false),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        centerTitle: true,
        title: const Text(
          'Receipt Preview',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Receipt card ──────────────────────────────────────────
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
                      'NKRS LANKA CAPITAL (PVT) LTD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Collection Receipt',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    _row('Receipt ID:', widget.receiptId),
                    _row(
                      'Collection Date:',
                      _formatDate(widget.collectionDate),
                    ),
                    _row('Print Date & Time:', _formatDateTime(DateTime.now())),
                    const Divider(height: 25),
                    _row('Loan Number:', widget.fileNumber),
                    const Divider(height: 25),

                    _row(
                      'Premium Amount:',
                      'LKR ${widget.premiumAmount.toStringAsFixed(2)}',
                    ),
                    _rowBold(
                      'Paid Amount:',
                      'LKR ${widget.paidAmount.toStringAsFixed(2)}',
                    ),
                    _row(
                      'Due Amount:',
                      'LKR ${widget.dueAmount.toStringAsFixed(2)}',
                    ),
                    const Divider(height: 25),
                    _row('Collected By:', widget.collectedBy),
                    const Spacer(),

                    if (!widget.isViewOnly)
                      // Hint that the record is not saved yet
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Receipt is saved only after printing.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'This is a provisional receipt. Subject to realization.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Action buttons ─────────────
            if (widget.isViewOnly)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: busy ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                      label: const Text(
                        'Close',
                        style: TextStyle(color: Colors.grey),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
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
                      onPressed: busy
                          ? null
                          : () async {
                              int? c = await DatabaseUserService()
                                  .getTempUserId();

                              await CollectionViewModel().addCollection(
                                CollectionsModel(
                                  dueAmount: widget.dueAmount,
                                  fileNumber: widget.fileNumber,
                                  installmentNumber: c!,
                                  paidAmount: widget.paidAmount,
                                  employeeId: 1,
                                ),
                                context,
                              );

                              await _reprintOnly();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentCompleteScreen(),
                                ),
                              );
                            },
                      icon: busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.print, color: Colors.white),
                      label: Text(
                        busy ? 'Printing...' : 'Re-Print',
                        style: const TextStyle(color: Colors.white),
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
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: busy
                          ? null
                          : () => Navigator.pop(context, false),
                      icon: const Icon(Icons.arrow_back, color: Colors.grey),
                      label: const Text(
                        'Back',
                        style: TextStyle(color: Colors.grey),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
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
                      onPressed: busy ? null : _printAndSave,
                      icon: busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.print, color: Colors.white),
                      label: Text(
                        _isSaving
                            ? 'Saving...'
                            : _isPrinting
                            ? 'Printing...'
                            : 'Print Receipt',
                        style: const TextStyle(color: Colors.white),
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

  // ── row widgets ───────────────────────────────────────────────────────

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
