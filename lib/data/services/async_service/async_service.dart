import 'dart:convert';
import 'package:http/http.dart' as http;

class AsyncService {
  final String _baseUrl = 'http://192.168.43.90:8080/api/v1/field';
  final int _time = 10;

  Future<List<Map<String, dynamic>>?> asyncCustomers(
    int page,
    Map<String, dynamic> customersId,
  ) async {
    try {
      final Uri url = Uri.parse('$_baseUrl/async/customers?page=$page');
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(customersId),
          )
          .timeout(Duration(seconds: _time));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("customer Sync Error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> asyncEmployees(
    int page,
    Map<String, dynamic> employeesId,
  ) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/async/fieldOfficers?page=$page',
      ); //important : change this url
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(employeesId),
          )
          .timeout(Duration(seconds: _time));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("employee Sync Error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> asyncInstallments(
    int page,
    Map<String, dynamic> id,
  ) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/async/installments?page=$page',
      ); //important : change this url
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(id),
          )
          .timeout(Duration(seconds: _time));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e)).toList();
        }
        return null;
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("installments Sync Error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> asyncInterestRates(
    int page,
    Map<String, dynamic> id,
  ) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/async/interests?page=$page',
      ); //important : change this url
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(id),
          )
          .timeout(Duration(seconds: _time));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e)).toList();
        }
        return null;
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("interestRates Sync Error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> asyncLoans(
    int page,
    Map<String, dynamic> loansId,
  ) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/async/loans?page=$page',
      ); //important : change this url
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(loansId),
          )
          .timeout(Duration(seconds: _time));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e)).toList();
        }
        return null;
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("loans Sync Error: $e");
      return null;
    }
  }
}
