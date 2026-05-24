import 'package:nkrs_app/data/services/async_service/async_service.dart';
import 'package:nkrs_app/data/services/database_service/database_get_service.dart';
import 'package:nkrs_app/data/services/database_service/database_put_service.dart';

class AsyncDatabaseTable {
  // final DatabaseService _databaseService = DatabaseService();
  final DatabaseGetService _databaseGetService = DatabaseGetService();
  final DatabasePutService _databasePutService = DatabasePutService();
  final AsyncService asyncService = AsyncService();
  int _pageNo = 0;

  Future<String> customersTable() async {
    List<int>? customerId = await _databaseGetService
        .getCustomersId(); //customer ID
    if (customerId == null) {
      return "'Cus' : Local database error";
      // throw Exception("Can't access to customer table");
    }

    _pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"nic": customerId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService.asyncCustomers(
        _pageNo,
        json,
      ); //call the server 'post'
      if (tableData == null) {
        return "'Cus' : Server or Connection or Error";
      }
      if (tableData.isEmpty) {
        return "Customer Sync Completed";
      }
      tableData = tableData.map((e) {
        e["sync"] = 1;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToCustomers(item));
        if (savedId == null) {
          //delete all sync column value is 1 rows
          return "Can't insert data customer";
        }
      }
      ++_pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }

  Future<String> employeesTable() async {
    List<int>? employeeId = await _databaseGetService
        .getEmployeesId(); //customer ID
    if (employeeId == null) {
      return "'Emp' : Local database error";
    }
    _pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"id": employeeId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService.asyncEmployees(
        _pageNo,
        json,
      ); //call the server 'post'
      if (tableData == null) {
        return "'Emp' : Server or Connection or Error";
      }
      if (tableData.isEmpty) {
        return "Employee Sync Completed";
      }
      tableData = tableData.map((e) {
        e["sync"] = 1;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToEmployees(item));
        if (savedId == null) {
          //delete all sync column value is 1 rows
          return "Can't insert data to employee";
        }
      }
      ++_pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }

  Future<String> loansTable() async {
    List<String>? loansId = await _databaseGetService
        .getLoansId(); //customer ID
    if (loansId == null) {
      return "'Loans' : Local database error";
    }
    _pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"file_number": loansId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService.asyncLoans(
        _pageNo,
        json,
      ); //call the server 'post'
      if (tableData == null) {
        return "'Loans' : Server or Connection or Error";
      }
      if (tableData.isEmpty) {
        return "Employee Sync Completed";
      }
      tableData = tableData.map((e) {
        e["sync"] = 1;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToLoans(item));
        if (savedId == null) {
          //delete all sync column value is 1 rows
          return "Can't insert data to loans";
        }
      }
      ++_pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }

  Future<String> installmentsTable() async {
    List<String>? installmentsId = await _databaseGetService
        .getinstallmentsId(); //customer ID
    if (installmentsId == null) {
      return "'instal' : Local database error";
    }
    _pageNo = 0;
    int? savedId;
    Map<String, dynamic> json = {"id": installmentsId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService
          .asyncInstallments(_pageNo, json); //call the server 'post'
      if (tableData == null) {
        return "'instal' : Server or Connection or Error";
      }
      if (tableData.isEmpty) {
        return "installments Sync Completed";
      }
      tableData = tableData.map((e) {
        e["sync"] = 1;
        return e;
      }).toList();
      for (var item in tableData) {
        savedId = (await _databasePutService.insertDataToinstallments(item));
        if (savedId == null) {
          //delete all sync column value is 1 rows
          return "Can't insert data to installments";
        }
      }
      ++_pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }
}
