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
  // User(
  //   id: 1,
  //   email: "email",
  //   name: "name",
  //   phoneNumber: "phoneNumber",
  //   address: "address",
  // );
  // List<Loan> get loans => _loans;
  bool get isLoading => _isLoading;

  Future<void> searchByNic(int nic) async {
    final LoanService service = LoanService();

    _isLoading = true;
    notifyListeners();

    try {
      final (user, loans) = await service.fetchUserAndLoans(nic);
      _user = user;
      _loans = loans;
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

    _isLoading = true;
    notifyListeners();

    try {
      final result = await service.getCustomerWithLoans(nic);
      if (result == null) {
        _user = null;
        _loans = [];
        return;
      }

      final userData = result['customer'] as Map<String, dynamic>;
      final loanData = result['loans'] as List<Map<String, dynamic>>;
      print(userData['name']);

      _user = User(
        id: userData['nic'],
        address: userData['address'].toString(),
        email: userData['email'].toString(),
        name: userData['name'].toString(),
        phoneNumber: userData['phone_number'].toString(),
      );
      // print(userData['address']);
      // print(userData['name']);

      // _loans = loanData.map((loan) {
      //   return Loan.fromMap(loan);
      // }).toList();
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
    // return [
    //   Loan(
    //     amount: 1000,
    //     interestRate: 1.1,
    //     noOfInstallments: 1,
    //     fileNumber: "121",
    //     documentCharge: 100,
    //   ),

    //   Loan(
    //     amount: 5000,
    //     interestRate: 2.5,
    //     noOfInstallments: 6,
    //     fileNumber: "122",
    //     documentCharge: 200,
    //   ),

    //   Loan(
    //     amount: 10000,
    //     interestRate: 3.0,
    //     noOfInstallments: 12,
    //     fileNumber: "123",
    //     documentCharge: 300,
    //   ),
    // ];
  }
}
