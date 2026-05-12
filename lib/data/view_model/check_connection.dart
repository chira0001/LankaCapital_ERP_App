import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class CheckConnection {
  static Future<bool> isInternet() async {
    try {
      // Step 1: Check network type
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        print("No network connection");
        return false;
      }

      // Step 2: Verify actual internet access
      final response = await http
          .get(Uri.parse('https://clients3.google.com/generate_204'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 204) {
        print("Internet available");
        return true;
      }

      return false;
    } on TimeoutException catch (_) {
      print("Connection timeout");
      return false;
    } catch (e) {
      print("No internet: $e");
      return false;
    }
  }
}
