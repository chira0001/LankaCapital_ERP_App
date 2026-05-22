import 'dart:convert';
import 'package:http/http.dart' as http;

class AsyncService {
  final String _baseUrl = 'http://192.168.43.90:8080/api/v1';

  Future<List<Map<String, dynamic>>?> syncCustomer(
    int page,
    Map<String, dynamic> customerId,
  ) async {
    try {
      final Uri url = Uri.parse('$_baseUrl/userTable?page=$page'); //important : change this url 
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(customerId),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          return [];
        }
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("Sync Error: $e");

      return null;
    }
  }
}
