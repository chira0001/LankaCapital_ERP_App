import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckConnection {
  // A global notifier holding the current internet state (defaults to true)
  static final ValueNotifier<bool> isOnline = ValueNotifier<bool>(true);

  static void initialize() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      if (results.contains(ConnectivityResult.none)) {
        isOnline.value = false;
      } else {
        isOnline.value = await _verifyDataFlow();
      }
    });
  }

  static Future<bool> _verifyDataFlow() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com/generate_204'))
          .timeout(const Duration(seconds: 4));
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
