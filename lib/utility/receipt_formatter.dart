import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

/// Builds the ESC/POS byte sequence for a collection receipt.
/// Keep this in sync with the on-screen layout in ReceiptPreviewPage.
class ReceiptFormatter {
  static Future<List<int>> buildCollectionReceipt({
    required String receiptId,
    required String fileNumber,
    required double premiumAmount,
    required double paidAmount,
    required double dueAmount,
    required String collectedBy,
    required DateTime collectionDate,
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);
    final bytes = <int>[];

    String pad(int d) => d.toString().padLeft(2, '0');
    final now = DateTime.now();
    final printedAt =
        '${now.year}-${pad(now.month)}-${pad(now.day)} ${pad(now.hour)}:${pad(now.minute)}';
    final collectedOn =
        '${collectionDate.year}-${pad(collectionDate.month)}-${pad(collectionDate.day)}';

    bytes.addAll(generator.text(
      'NKRS LANKA CAPITAL (PVT) LTD',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ));
    bytes.addAll(generator.text(
      'Collection Receipt',
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.hr());

    bytes.addAll(_line(generator, 'Receipt ID', receiptId));
    bytes.addAll(_line(generator, 'Collection Date', collectedOn));
    bytes.addAll(_line(generator, 'Printed', printedAt));
    bytes.addAll(generator.hr());

    bytes.addAll(_line(generator, 'Loan Number', fileNumber));
    bytes.addAll(generator.hr());

    bytes.addAll(_line(generator, 'Premium Amount', 'LKR ${premiumAmount.toStringAsFixed(2)}'));
    bytes.addAll(_line(generator, 'Paid Amount', 'LKR ${paidAmount.toStringAsFixed(2)}', bold: true));
    bytes.addAll(_line(generator, 'Due Amount', 'LKR ${dueAmount.toStringAsFixed(2)}'));
    bytes.addAll(generator.hr());

    bytes.addAll(_line(generator, 'Collected By', collectedBy));
    bytes.addAll(generator.feed(1));

    bytes.addAll(generator.text(
      'This is a provisional receipt.',
      styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1),
    ));
    bytes.addAll(generator.text(
      'Subject to realization.',
      styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1),
    ));

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }

  static List<int> _line(Generator generator, String label, String value, {bool bold = false}) {
    return generator.row([
      PosColumn(text: label, width: 6, styles: const PosStyles(align: PosAlign.left)),
      PosColumn(
        text: value,
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: bold),
      ),
    ]);
  }
}
