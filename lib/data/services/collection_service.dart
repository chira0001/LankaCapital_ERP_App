import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/models/collections_model.dart';

class CollectionService {
  Future<String?> addCollectionToServer(CollectionsModel collection) async {
    final Uri url = Uri.parse('${UserService.baseUrl}/add/collection');

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(collection.toServer()),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return '';
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["message"].toString();
      }
    } catch (e) {
      return null;
    }
  }
}
