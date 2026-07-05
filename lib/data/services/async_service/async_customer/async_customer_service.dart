import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nkrs_app/models/async_manage_model/manage_customer_model.dart';
import 'package:nkrs_app/models/update_model/customer_update.dart';

class AsyncCustomerService {
  final String _baseUrl = 'http://10.59.109.130:8080/api/v1/field';
  final int _time = 10;

  Future<List<ManageCustomerModel>?> manageCustomers(int page) async {
    try {
      final Uri url = Uri.parse('$_baseUrl/manage/customer?page=$page');
      final response = await http
          .get(url, headers: {"Content-Type": "application/json"})
          .timeout(Duration(seconds: _time));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data
              .map(
                (e) => ManageCustomerModel.fromServer(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList();
        }
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<CustomerUpdate>?> asyncCustomers(
    Map<String, dynamic> customersId,
  ) async {
    try {
      final Uri url = Uri.parse('$_baseUrl/async/customers');
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
          return data.map((e) => CustomerUpdate.fromServer(e)).toList();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
