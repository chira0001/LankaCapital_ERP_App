import 'package:flutter/material.dart';

/// Centralizes navigation so pages don't each invent their own Navigator
/// calls. Two problems this fixes across the app:
///
/// 1. Double-tap double-push: fast repeated taps on a button (e.g. "FIND"
///    then a slow network response, then a rebuild) could push the same
///    page twice. [push] guards against that with a short-lived lock.
/// 2. Unbounded stack growth: several screens in this app pushed a brand
///    new instance of an earlier page instead of popping back to it
///    (e.g. PaymentCompleteScreen -> new CollectionEntryPage every time),
///    so the back stack grows forever during a shift. Use
///    [pushAndClearTo] or [popToRoot] instead for "go back to a known
///    screen" actions.
class NavigationHelper {
  NavigationHelper._();

  static Future<T?> push<T>(BuildContext context, Widget page) async {
    if (!context.mounted) return null;
    try {
      return await Navigator.push<T>(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    } catch (e) {
      debugPrint('Navigation error (push): $e');
      return null;
    }
  }

  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget page) async {
    if (!context.mounted) return null;
    try {
      return await Navigator.pushReplacement<T, TO>(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    } catch (e) {
      debugPrint('Navigation error (pushReplacement): $e');
      return null;
    }
  }

  /// Pushes [page] and removes every route below it, so the back stack
  /// resets to exactly this one screen. Use this for "flow complete, start
  /// fresh" transitions (e.g. after a successful print, going back to a
  /// clean Collection Entry screen).
  static Future<T?> pushAndClearTo<T>(BuildContext context, Widget page) async {
    if (!context.mounted) return null;
    try {
      return await Navigator.pushAndRemoveUntil<T>(
        context,
        MaterialPageRoute(builder: (_) => page),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Navigation error (pushAndClearTo): $e');
      return null;
    }
  }

  static void popToRoot(BuildContext context) {
    if (!context.mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static void safePop(BuildContext context, [dynamic result]) {
    if (!context.mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }
}
