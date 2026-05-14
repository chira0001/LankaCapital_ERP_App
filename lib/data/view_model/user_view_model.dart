import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _service = UserService();

  User? _foundUser;
  String? _errorMessage;

  User? get foundUser => _foundUser;
  String? get errorMessage => _errorMessage;

  // void getUser(String nic) {
  //   _foundUser = null;
  //   _errorMessage = null;
  //   if (nic.isEmpty) {
  //     _errorMessage = "Please enter a NIC number";
  //     notifyListeners();
  //     return;
  //   }

  //   try {
  //     final User? user = _userRepository.user;

  //     if (user != null && user.id == nic) {
  //       _foundUser = user;
  //       _errorMessage = null;
  //     } else {
  //       _errorMessage = "No record found for NIC: $nic";
  //       _foundUser = null;
  //     }
  //   } catch (e) {
  //     _errorMessage = "An error occurred while retrieving user data.";
  //     _foundUser = null;
  //   }
  //   notifyListeners();
  // }
  Future<void> fetchLoans() async {
    try {
      _foundUser = await _service.fetchAllUsers("faf", "15"); // add jwt token
    } catch (e) {
      print("Failed to user loans.");
      throw Exception("Can't upload data $e");
    }
  }
}
