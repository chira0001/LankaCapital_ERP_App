import 'dart:async';
import 'package:flutter/material.dart';

void showCustomTopMessageBox(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  final animationController = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 600),
    reverseDuration: const Duration(milliseconds: 350),
  );

  final slideAnimation =
      Tween<Offset>(
        begin: const Offset(0, -1.5),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        ),
      );

  overlayEntry = OverlayEntry(
    builder: (context) => SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: slideAnimation,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isError
                        ? const Color.fromARGB(109, 207, 3, 0)
                        : Colors.green.shade400,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(162, 0, 0, 0),
                      blurRadius: 30.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      isError
                          ? Icons.error_outline_sharp
                          : Icons.check_circle_outline,
                      color: isError
                          ? Colors.red.shade400
                          : Colors.green.shade400,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Color.fromARGB(197, 0, 0, 0),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await animationController.reverse();
                        if (overlayEntry.mounted) {
                          overlayEntry.remove();
                        }
                        animationController.dispose();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  animationController.forward();

  Timer(const Duration(seconds: 4), () async {
    if (overlayEntry.mounted) {
      await animationController.reverse();
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
      animationController.dispose();
    }
  });
}
