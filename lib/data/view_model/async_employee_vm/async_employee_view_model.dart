// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/async_service/async_employee/async_database_employee.dart';
import 'package:nkrs_app/data/services/async_service/async_employee/async_employee_service.dart';
import 'package:nkrs_app/models/async_manage_model/manage_employee_model.dart';
import 'package:nkrs_app/models/update_model/employee_update.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class AsyncEmployeeViewModel {
  final AsyncEmployeeService _asyncEmployeeService = AsyncEmployeeService();
  final AsyncDatabaseEmployee _asyncDatabaseEmployee = AsyncDatabaseEmployee();

  final int limit = 10;

  Future<bool?> ManageEmployeesTabel(BuildContext context) async {
    int pageNo = 0;
    await _asyncDatabaseEmployee.clearTempEmployee();
    await _asyncDatabaseEmployee.clearUpdateEmployee();

    while (true) {
      //async
      List<ManageEmployeeModel>? serverData = await _asyncEmployeeService
          .manageEmployees(pageNo);

      if (serverData == null) return false;
      if (serverData.isEmpty) {
        break;
      }

      bool? table = await _asyncDatabaseEmployee.insertTempEmployee(serverData);
      if (table == null) {
        await _asyncDatabaseEmployee.clearTempEmployee();
        await _asyncDatabaseEmployee.clearUpdateEmployee();
        break;
      }
      ++pageNo;
    }

    int offset = 0;
    while (true) {
      //
      final customerIds = await _asyncDatabaseEmployee.getEmployeesIds(
        limit: limit,
        offset: offset,
      );
      if (customerIds.isEmpty) {
        break;
      }
      Map<String, dynamic> json = {"id": customerIds};
      List<EmployeeUpdate>? tableData = await _asyncEmployeeService
          .asyncEmployees(json);
      if (tableData == null) {
        AppTopSnackBar.info(
          context,
          "Server or Connection or Error : Employee",
        );
        break;
      }
      if (tableData.isEmpty) {
        break;
      }

      for (var employee in tableData) {
        employee.sync = 2;
      }

      for (var item in tableData) {
        final savedId = (await _asyncDatabaseEmployee.insertEmployeeToTable(
          item,
        ));
        if (savedId == null) {
          ScaffoldMessageBottom.show(context, "Can't insert data Employee");
          return false;
        }
      }
      offset += limit;
    }

    int offsets = 0; //update
    while (true) {
      final customerIds = await _asyncDatabaseEmployee.getUpdateEmployees(
        limit: limit,
        offset: offsets,
      );

      if (customerIds.isEmpty) {
        break;
      }
      Map<String, dynamic> json = {"id": customerIds};
      List<EmployeeUpdate>? tableData = await _asyncEmployeeService
          .asyncEmployees(json);
      if (tableData == null) {
        AppTopSnackBar.info(
          context,
          "Server or Connection or Error : Customers",
        );
        break;
      }
      if (tableData.isEmpty) {
        break;
      }
      for (var item in tableData) {
        final savedId = (await _asyncDatabaseEmployee.updateEmployeeToTable(
          item,
        ));
        if (savedId == null) {
          ScaffoldMessageBottom.show(context, "Can't insert data Customers");
          return false;
        }
      }
      offsets += limit;
    }

    await _asyncDatabaseEmployee.deleteEmployees();
    await _asyncDatabaseEmployee.resetEmployees();
    await _asyncDatabaseEmployee.clearTempEmployee();
    await _asyncDatabaseEmployee.clearUpdateEmployee();
    return true;
  }
}
