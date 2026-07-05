import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nkrs_app/data/services/api_config.dart';
import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/models/interest_rate_model.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/installment_model.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:http/http.dart' as http;
import 'package:nkrs_app/models/user_model.dart';

class LoanService {
  static const String _baseUrl = 'http://10.59.109.130/api/v1/field';
  late final String _message;
  String? get message => _message;

  Future<(User, List<Loan>)> fetchUserAndLoans(int nic) async {
    final Uri url = Uri.parse(
      '${ApiConfig.baseUrl}/field/customers/loans/$nic',
    );
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _message = '';
        try {
          final Map<String, dynamic> data = json.decode(response.body);

          print("JSON: $data");

          final user = User.fromJson(data);
          print("User parsed");

          final loans = (data['loans'] as List).map((e) {
            print("Loan JSON: $e");
            return Loan.fromJson(e);
          }).toList();

          print("Loans parsed");

          return (user, loans);
        } catch (e, s) {
          print("ERROR: $e");
          print(s);
          rethrow;
        }
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

  // Future<String?> addLoan(AddLoanModel loan) async {
  //   final Uri url = Uri.parse('${ApiConfig.baseUrl}/field/customers/loans');

  //   try {
  //     final response = await http
  //         .post(
  //           url,
  //           headers: {"Content-Type": "application/json"},
  //           body: jsonEncode(loan.toJsonServer()),
  //         )
  //         .timeout(Duration(seconds: 10));
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return '';
  //     } else {
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       return data["message"].toString();
  //     }
  //   } catch (e) {
  //     debugPrint("Failed $e");
  //     return null;
  //   }
  // }

  Future<String?> addExistingLoan(AddLoanModel loan) async {
    final Uri url = Uri.parse('${UserService.baseUrl}/customers/loans');

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

  Future<List<InstallmentModel>?> getInstallments() async {
    final Uri url = Uri.parse('${ApiConfig.baseUrl}/recep/installments');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("$data : debug data");

        return (data as List).map((e) => InstallmentModel.fromJson(e)).toList();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<List<InterestRateModel>?> getInterestRates() async {
    final Uri url = Uri.parse('${UserService.baseUrl}/installments');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("$data : debug data");

        return (data as List).map((e) => InterestRateModel.fromMap(e)).toList();
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
