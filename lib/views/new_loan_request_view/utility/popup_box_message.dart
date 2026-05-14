import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

void showTopNotification(BuildContext context, String message) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  late Timer autoCloseTimer;

  final controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 600),
  );

  final offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: const Offset(0.0, 0.0),
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

  overlayEntry = OverlayEntry(
    builder: (context) {
      return SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: SlideTransition(
              position: offsetAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(137, 0, 0, 0),
                        blurRadius: 30.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: const Color.fromARGB(82, 90, 90, 90),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.warning_2_copy,
                        color: const Color.fromARGB(255, 180, 7, 7),
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Color.fromARGB(194, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlayState.insert(overlayEntry);
  controller.forward();

  Future<void> dismissNotification() async {
    if (autoCloseTimer.isActive) {
      autoCloseTimer.cancel();
    }
    await controller.reverse();
    overlayEntry.remove();
    controller.dispose();
  }

  autoCloseTimer = Timer(const Duration(seconds: 5), () {
    dismissNotification();
  });
}
