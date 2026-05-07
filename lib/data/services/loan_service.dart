import 'dart:convert';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:http/http.dart' as http;
import 'package:nkrs_app/models/user_model.dart';

class LoanService {
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
      final Uri url = Uri.parse('http://10.0.2.2:8080/api/v1/recep/customers/${nic}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: json.encode({'id': nic}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final user = User.fromJson(data['user']);
        final loans = (data['loans'] as List)
            .map((json) => Loan.fromJson(json))
            .toList();

        return (user, loans);
      } else {
        // ignore: avoid_print
        print("Error null data in user & loans");
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

  Future<void> addLoan(AddLoanModel loan) async{
      final Uri url = Uri.parse('https://your-api.com/user-summary');
      
      try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(loan.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Response ${response}");
        // Product newProduct = Product.formJson(json.decode(response.body));
        // return newProduct;
      } else {
        print("Failed to loan product");
        throw Exception("Failed");
      }
    } catch (e) {
      print("Failed ${e}");
      throw Exception("Failed to add loan ${e}");
    }
  }
}
