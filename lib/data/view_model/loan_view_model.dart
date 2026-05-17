import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service.dart';
import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';

class LoanViewModel extends ChangeNotifier {
  late User? _user;
  List<Loan> _loans = [];
  bool _isLoading = false;

  User? get user => _user;

  bool get isLoading => _isLoading;

  Future<void> searchByNic(int nic) async {
    final LoanService service = LoanService();

    _isLoading = true;
    notifyListeners();

    try {
      final (user, loans) = await service.fetchUserAndLoans(nic);
      _user = user;
      _loans = loans;
      _isLoading = false;
    } catch (e) {
      _user = null;
      _loans = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchByNicOffline(int nic) async {
    final DatabaseService service = DatabaseService();
    notifyListeners();

    try {
      final result = await service.getCustomerWithLoans(nic);
      if (result == null) {
        _user = null;
        _loans = [];
        return;
      }

      final userData = result['customer'] as Map<String, dynamic>;

      // print(userData['name']);

      _user = User(
        id: userData['nic'],
        address: userData['address'].toString(),
        email: userData['email'].toString(),
        name: userData['name'].toString(),
        phoneNumber: userData['phone_number'].toString(),
      );
    } catch (e) {
      _user = null;
      _loans = [];
      debugPrint("Offline search error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _user = null;
    _loans = [];
    notifyListeners();
  }

  Future<List<Loan>> getLoansByID() async {
    return _loans;
  }
}
