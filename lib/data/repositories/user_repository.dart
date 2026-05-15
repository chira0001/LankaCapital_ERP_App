import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/models/user_model.dart';
import 'package:flutter/foundation.dart';

class UserRepository {
  final UserService _service = UserService();
  late User _user;
  User get user => _user;

  Future<void> fetchLoans() async {
    try {
      _user = await _service.fetchAllUsers("faf","15"); // add jwt token
    } catch (e) {
      debugPrint("Failed to user loans.");
    }
  }
}
