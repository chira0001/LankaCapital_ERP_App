import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:http/http.dart' as http;
import 'package:nkrs_app/models/user_model.dart';
// import 'package:nkrs_app/views/new_loan_request_view/utility/check_connection.dart';

class LoanService {
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
    );

    try {
      final response = await http.get(url);
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

  Future<bool> addLoan(AddLoanModel loan) async {
    final Uri url = Uri.parse(
      'http://192.168.43.90/api/v1/field/customers/loans',
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(loan.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response $response");
        // Product newProduct = Product.formJson(json.decode(response.body));
        // return newProduct;
        return true;
      } else {
        debugPrint("Failed to loan product");
        return false;
      }
    } catch (e) {
      debugPrint("Failed $e");
      throw Exception("Failed to add loan $e");
    }
  }
}
