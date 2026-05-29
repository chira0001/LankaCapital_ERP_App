import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckConnection {
  static final ValueNotifier<bool> isOnline = ValueNotifier<bool>(false);

  /// true  = Auto Mode real internet checking
  /// false = Force device offline
  static final ValueNotifier<bool> autoMode = ValueNotifier<bool>(true);

  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  static Future<void> initialize() async {
    await _subscription?.cancel();

    await refreshConnection();

    _subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      if (!autoMode.value) {
        isOnline.value = false;
        return;
      }

      if (results.contains(ConnectivityResult.none)) {
        isOnline.value = false;
      } else {
        isOnline.value = await _verifyDataFlow();
      }
    });
  }

  static Future<void> setAutoMode(bool value) async {
    autoMode.value = value;
    await refreshConnection();
  }

  static Future<void> refreshConnection() async {
    if (!autoMode.value) {
      isOnline.value = false;
      return;
    }

    isOnline.value = await _verifyDataFlow();
  }

  static Future<bool> _verifyDataFlow() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com/generate_204'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  static Future<void> dispose() async {
    await _subscription?.cancel();
  }
}