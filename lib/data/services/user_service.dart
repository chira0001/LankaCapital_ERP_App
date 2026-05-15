import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:nkrs_app/models/user_model.dart';

class UserService {
  Future<User> fetchAllUsers(String jwtToken, String nic) async {
    final Uri url = Uri.parse('https://fakestoreapi.com/products');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: json.encode({'nic', nic}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint("fetch the user");

        return User.fromJson(responseData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Failt to get a user data $e");
      throw Exception('Request failed: $e');
    }
  }
}
