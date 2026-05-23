import 'dart:convert';
import 'package:http/http.dart' as http;

class AsyncService {
  final String _baseUrl = 'http://192.168.43.90:8080/api/v1';

  Future<List<Map<String, dynamic>>?> asyncCustomers(
    int page,
    Map<String, dynamic> customersId,
  ) async {
    try {
      final Uri url = Uri.parse(
        '$_baseUrl/userTable?page=$page',
      ); //important : change this url
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(customersId),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          return [];
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
        '$_baseUrl/employeeTable?page=$page',
      ); //important : change this url
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(employeesId),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          return [];
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("employee Sync Error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> asyncLoans(
    int page,
    Map<String, dynamic> loansId,
  ) async {try {
      final Uri url = Uri.parse(
        '$_baseUrl/loanTable?page=$page',
      ); //important : change this url
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(loansId),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          return [];
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("loans Sync Error: $e");
      return null;
    }}
}
