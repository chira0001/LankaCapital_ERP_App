import 'package:flutter/material.dart';


class PaymentCompleteScreen extends StatelessWidget {
  const PaymentCompleteScreen({super.key});

  final Color primaryGreen = const Color(0xFF1CE865);
  final Color backgroundColor = const Color(0xFFF4F9F6);
  final Color titleColor = const Color(0xFF101426);
  final Color subtitleColor = const Color(0xFF75818F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withValues(alpha: 102),
                      blurRadius: 40,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.black, size: 56),
              ),
              const SizedBox(height: 48),
              Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Transaction processed successfully.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: subtitleColor),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Receipt Printed',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: primaryGreen),
                  ),
                ],
              ),
              const Spacer(flex: 4),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withValues(alpha: 77),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      // Pop back to the CollectionEntryPage with 'true'
                      // so it knows to refresh the list and clear the form.
                      Navigator.pop(context, true);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_rounded, color: Colors.black, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Done',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
