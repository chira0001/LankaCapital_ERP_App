import 'package:nkrs_app/data/services/async_service/async_service.dart';
import 'package:nkrs_app/data/services/database_service/database_get_service.dart';
import 'package:nkrs_app/data/services/database_service.dart';

class AsyncDatabaseTable {
  DatabaseService _databaseService = DatabaseService();
  DatabaseGetService _databaseGetService = DatabaseGetService();
  AsyncService asyncService = AsyncService();

  Future<String> customerTable() async {
    List<int> customerId = await _databaseGetService.getCustomerId();
    int pageNo = 0;

    Map<String, dynamic> jsonCustomerId = {"nic": customerId};

    while (true) {
      List<Map<String, dynamic>>? tableData = await asyncService.syncCustomer(
        pageNo,
        jsonCustomerId,
      );
      if (tableData == null) {
        return "Server Error";
      }
      if (tableData.isEmpty) {
        return "Sync Completed";
      }
      tableData = tableData.map((e) {
        e["sync"] = 1;
        return e;
      }).toList();
      for (var item in tableData) {
        // await DatabaseService().insertAll(item);
      }
      ++pageNo;
      // ignore: avoid_print
      print("Saved ${tableData.length} rows");
    }
  }
}
