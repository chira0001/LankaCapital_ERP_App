import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nkrs_app/models/new_user_model.dart';
import 'package:nkrs_app/models/user_model.dart';

class UserService {
  static const String baseUrl = 'http://192.168.43.90:8080/api/v1/field';

  Future<User?> findUserInfoById(int nic) async {
    final Uri url = Uri.parse('$baseUrl/customers/loans/$nic');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final User user = User.fromJson(data);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> addCustomerAndLoan(NewUserModel customer) async {
    final Uri url = Uri.parse('$baseUrl/add/customer');
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(customer.toServer()),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return '';
      } else if (response.statusCode == 409) {
        // return jsonDecode(response.body);
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["message"].toString();
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["message"].toString();
      }
    } catch (e) {
      return null;
    }
  }
}
