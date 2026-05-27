import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/installments_model.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:http/http.dart' as http;
import 'package:nkrs_app/models/user_model.dart';
import 'package:nkrs_app/data/services/api_config.dart';
// import 'package:nkrs_app/views/new_loan_request_view/utility/check_connection.dart';

class LoanService {
  static const String _baseUrl = 'http://192.168.43.90:8080/api/v1/field';
  late final String _message;
  String? get message => _message;

  static const String jwtToken = "he;fsf";
  // Future<List<Loan>> fetchAllLoans(String jwtToken) async {
  //   final Uri url = Uri.parse('https://fakestoreapi.com/products');

  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $jwtToken',
  //       },
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final List<dynamic> responseData = json.decode(response.body);
  //       List<Loan> loans = responseData.map((json) {
  //         return Loan.fromJson(json);
  //       }).toList();
  //       print("fetch the loan list");

  //       return loans;
  //     } else if (response.statusCode == 401) {
  //       throw Exception('Unauthorized: Please log in again.');
  //     } else {
  //       throw Exception('Server error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print("Failt to get data ${e}");
  //     throw Exception('Request failed: $e');
  //   }
  // }

  Future<(User, List<Loan>)> fetchUserAndLoans(int nic) async {
    final Uri url = Uri.parse(
      'http://192.168.43.90:8080/api/v1/recep/customers/loans/$nic',
      '${ApiConfig.baseUrl}/recep/customers/loans/$nic',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        _message = '';
        final Map<String, dynamic> data = json.decode(response.body);
        final user = User.fromJson(data);
        final loans = (data['loans'] as List)
            .map((json) => Loan.fromJson(json))
            .toList();

        return (user, loans);
      } else if (response.statusCode == 404) {
        // final Map<String, dynamic> error = json.decode(response.body);
        _message = "Invalid user ID : $nic";
        throw Exception("Error");
      } else {
        _message = "Database or Server error";
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _message = 'Failed to fetch data : $e';
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<String?> addLoan(AddLoanModel loan) async {
    final Uri url = Uri.parse('$_baseUrl/customers/loans');
  Future<bool> addLoan(AddLoanModel loan) async {
    final Uri url = Uri.parse(
      '${ApiConfig.baseUrl}/field/customers/loans',
    );

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(loan.toJsonServer()),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return '';
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["message"].toString();
      }
    } catch (e) {
      debugPrint("Failed $e");
      return null;
    }
  }

  Future<List<InstallmentsModel>?> getInstallments() async {
    final Uri url = Uri.parse(
      'http://192.168.43.90:8080/api/v1/recep/installments',
    );
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("$data : debug data");

        return (data as List)
            .map((e) => InstallmentsModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
