import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
