import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/collections_model.dart';
import 'package:nkrs_app/models/sync_loan_resp_model.dart';
import 'package:nkrs_app/models/user_model.dart';

class SyncService {
  Future<List<int>?> syncCustomers(List<User> user) async {
    final Uri url = Uri.parse('${UserService.baseUrl}/sync/customer');
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(user.map((e) => e.toJson()).toList()),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<int>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      debugPrint("Failed: $e");
      return null;
    }
  }

  Future<List<SyncLoanRespModel>?> syncLoans(List<AddLoanModel> loans) async {
    final Uri url = Uri.parse('${UserService.baseUrl}/sync/loan');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loans.map((e) => e.toJsonSync()).toList()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> result = jsonDecode(response.body);
        return result.map((e) => SyncLoanRespModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('syncLoans error: $e');
      return null;
    }
  }

  Future<List<int>?> syncCollections(List<CollectionsModel> loans) async {
    final Uri url = Uri.parse('${UserService.baseUrl}/sync/collection');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loans.map((e) => e.toSync()).toList()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<int>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      print('syncLoans error: $e');
      return null;
    }
  }
}
