// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/async_service/async_service.dart';
import 'package:nkrs_app/data/services/database_service/database_get_service.dart';
import 'package:nkrs_app/data/services/database_service/database_put_service.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class AsyncDatabaseTable {
  // final DatabaseService _databaseService = DatabaseService();
  final DatabaseGetService _databaseGetService = DatabaseGetService();
  final DatabasePutService _databasePutService = DatabasePutService();
  final AsyncService asyncService = AsyncService();
  //1
  Future<bool?> customersTable(BuildContext context) async {
    List<int>? customerId = await _databaseGetService
        .getCustomersId(); //customer ID
    if (customerId == null) {
      ScaffoldMessageBottom.show(context, "Local database error : Customers");
      return false;
    }

    int pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"nic": customerId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService.asyncCustomers(
        pageNo,
        json,
      ); //call the server 'post'
      if (tableData == null) {
        ScaffoldMessageBottom.show(
          context,
          "Server or Connection or Error : Customers",
        );
        return false;
      }
      if (tableData.isEmpty) {
        ScaffoldMessageBottom.show(context, "Customers Sync Completed");
        return true;
      }
      tableData = tableData.map((e) {
        e["sync"] = 2;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToCustomers(item));
        if (savedId == null) {
          //delete all sync column value is 1 rows
          ScaffoldMessageBottom.show(context, "Can't insert data Customers");
          return false;
        }
      }
      ++pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }

  //2
  Future<bool?> employeesTable(BuildContext context) async {
    List<int>? employeeId = await _databaseGetService
        .getEmployeesId(); //customer ID
    if (employeeId == null) {
      ScaffoldMessageBottom.show(context, "Local database error : Employees");
      return false;
    }
    int pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"id": employeeId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService.asyncEmployees(
        pageNo,
        json,
      ); //call the server 'post'
      if (tableData == null) {
        ScaffoldMessageBottom.show(
          context,
          "Server or Connection or Error : Employees",
        );
        return false;
      }
      if (tableData.isEmpty) {
        ScaffoldMessageBottom.show(context, "Employees Sync Completed");
        return true;
      }
      tableData = tableData.map((e) {
        e["sync"] = 2;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToEmployees(item));
        if (savedId == null) {
          //delete all sync column value is 1 rows
          ScaffoldMessageBottom.show(context, "Can't insert data Employees");
          return false;
        }
      }
      ++pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }

  //5
  Future<bool?> loansTable(BuildContext context) async {
    List<String>? loansId = await _databaseGetService
        .getLoansId(); //customer ID
    if (loansId == null) {
      ScaffoldMessageBottom.show(context, "Local database error : Loans");
      return false;
    }
    int pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"file_number": loansId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService.asyncLoans(
        pageNo,
        json,
      ); //call the server 'post'
      if (tableData == null) {
        ScaffoldMessageBottom.show(
          context,
          "Server or Connection or Error : Loans",
        );
        return false;
      }
      if (tableData.isEmpty) {
        ScaffoldMessageBottom.show(context, "Loans Sync Completed");
        return true;
      }
      tableData = tableData.map((e) {
        e["sync"] = 2;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToLoans(item));
        print(savedId);
        if (savedId == null) {
          ScaffoldMessageBottom.show(context, "Can't insert data Loans");
          return false;
        }
        // if(savedId ==){
        //   ScaffoldMessageBottom.show(context, "Can't insert data Loans");
        //   return false;
        // }
      }
      ++pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }

  //3
  Future<bool?> installmentsTable(BuildContext context) async {
    List<String>? installmentsId = await _databaseGetService
        .getInstallmentsId(); //customer ID
    if (installmentsId == null) {
      ScaffoldMessageBottom.show(
        context,
        "Local database error : Installments",
      );
      return false;
    }
    int pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"id": installmentsId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService
          .asyncInstallments(pageNo, json); //call the server 'post'
      if (tableData == null) {
        ScaffoldMessageBottom.show(
          context,
          "Server or Connection or Error : Installments",
        );
        return false;
      }
      if (tableData.isEmpty) {
        ScaffoldMessageBottom.show(context, "Installments Sync Completed");
        return true;
      }
      tableData = tableData.map((e) {
        e["sync"] = 2;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToinstallments(item));
        if (savedId == null) {
          //delete all sync column value is 1 rows
          ScaffoldMessageBottom.show(context, "Can't insert data Installments");
          return false;
        }
      }
      ++pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }

  Future<bool?> interestRatesTable(BuildContext context) async {
    List<String>? interestsId = await _databaseGetService
        .getInterestRatesId(); //customer ID
    if (interestsId == null) {
      ScaffoldMessageBottom.show(
        context,
        "Local database error : Interest Rates",
      );
      return false;
    }
    int pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"id": interestsId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService
          .asyncInterestRates(pageNo, json); //call the server 'post'
      if (tableData == null) {
        ScaffoldMessageBottom.show(
          context,
          "Server or Connection or Error : Interest Rates",
        );
        return false;
      }
      if (tableData.isEmpty) {
        ScaffoldMessageBottom.show(context, "Interest Rates Sync Completed");
        return true;
      }
      tableData = tableData.map((e) {
        e["sync"] = 2;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToInterests(item));
        if (savedId == null) {
          //delete all sync column value is 1 rows
          ScaffoldMessageBottom.show(
            context,
            "Can't insert data Interest Rates",
          );
          return false;
        }
      }
      ++pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }
}
