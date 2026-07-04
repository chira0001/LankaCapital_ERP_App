import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nkrs_app/models/async_manage_model/manage_employee_model.dart';
import 'package:nkrs_app/models/update_model/employee_update.dart';

class AsyncEmployeeService {
  final String _baseUrl = 'http://192.168.43.90:8080/api/v1/field';
  final int _time = 10;

  Future<List<ManageEmployeeModel>?> manageEmployees(int page) async {
    try {
      final Uri url = Uri.parse('$_baseUrl/manage/employee?page=$page');
      final response = await http
          .get(url, headers: {"Content-Type": "application/json"})
          .timeout(Duration(seconds: _time));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data
              .map(
                (e) => ManageEmployeeModel.fromServer(
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

  Future<List<EmployeeUpdate>?> asyncEmployees(
    Map<String, dynamic> customersId,
  ) async {
    try {
      final Uri url = Uri.parse('$_baseUrl/async/fieldOfficers');
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
          return data.map((e) => EmployeeUpdate.fromServer(e)).toList();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
