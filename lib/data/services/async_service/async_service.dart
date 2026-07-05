import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nkrs_app/models/async_manage_model/manage_customer_model.dart';
import 'package:nkrs_app/models/update_model/customer_update.dart';

class AsyncService {
  final String _baseUrl = 'http://10.59.109.130:8080/api/v1/field';
  final int _time = 10;

  // Future<List<Map<String, dynamic>>?> asyncCustomers(
  //   int page,
  //   Map<String, dynamic> customersId,
  // ) async {
  //   try {
  //     final Uri url = Uri.parse('$_baseUrl/async/customers?page=$page');
  //     final response = await http
  //         .post(
  //           url,
  //           headers: {"Content-Type": "application/json"},
  //           body: jsonEncode(customersId),
  //         )
  //         .timeout(Duration(seconds: _time));
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = jsonDecode(response.body);
  //       if (data is List) {
  //         return data.map((e) => Map<String, dynamic>.from(e)).toList();
  //       }
  //     }
  //     return null;
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("customer Sync Error: $e");
  //     return null;
  //   }
  // }

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

  // Future<List<ManageCustomerModel>?> manageCustomers(int page) async {
  //   try {
  //     final Uri url = Uri.parse('$_baseUrl/manage/customer?page=$page');
  //     final response = await http
  //         .get(url, headers: {"Content-Type": "application/json"})
  //         .timeout(Duration(seconds: _time));

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = jsonDecode(response.body);
  //       if (data is List) {
  //         return data
  //             .map(
  //               (e) => ManageCustomerModel.fromServer(
  //                 Map<String, dynamic>.from(e),
  //               ),
  //             )
  //             .toList();
  //       }
  //       return null;
  //     }
  //     return null;
  //   } catch (e) {
  //     // print("Manage Customers Sync Error: $e");
  //     return null;
  //   }
  // }

  // Future<List<CustomerUpdate>?> asyncCustomers(
  //   Map<String, dynamic> customersId,
  // ) async {
  //   try {
  //     final Uri url = Uri.parse('$_baseUrl/async/customers');
  //     final response = await http
  //         .post(
  //           url,
  //           headers: {"Content-Type": "application/json"},
  //           body: jsonEncode(customersId),
  //         )
  //         .timeout(Duration(seconds: _time));
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = jsonDecode(response.body);
  //       if (data is List) {
  //         return data.map((e) => CustomerUpdate.fromServer(e)).toList();
  //       }
  //     }
  //     return null;
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("customer Sync Error: $e");
  //     return null;
  //   }
  // }

  
}
