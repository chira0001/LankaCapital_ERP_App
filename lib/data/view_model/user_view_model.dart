// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_user_service.dart';
import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/models/new_customer_model.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class UserViewModel {
  Future<bool> newCustomer(
    NewCustomerModel customer,
    BuildContext context,
  ) async {
    try {
      String? m;
      if (CheckConnection.isOnline.value) {
        m = await UserService().addCustomerAndLoan(customer);
        if (m == null) {
          ScaffoldMessageBottom.show(context, "Server Connection failed");
          return false;
        }
      } else {
        m = await DatabaseUserService().addCustomerAndLoan(customer);
        if (m == null) {
          ScaffoldMessageBottom.show(context, "Server Connection failed");
          return false;
        }
      }
      if (m.isEmpty) {
        return true;
      } else {
        AppTopSnackBar.error(
          context,
          m,
          showClose: true,
          duration: Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
