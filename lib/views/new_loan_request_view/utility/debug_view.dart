import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service.dart';
import 'package:nkrs_app/data/view_model/async_database_table.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/utility/constanst.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/popup_box_message.dart';
import 'package:nkrs_app/views/sync_view/sync_async_view.dart';

class DebugView extends StatefulWidget {
  const DebugView({super.key});

  @override
  State<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  @override
  void initState() {
    super.initState();
    CheckConnection.initialize();
  }

  DatabaseService databaseService = DatabaseService();
  AsyncDatabaseTable asyncDatabaseTable = AsyncDatabaseTable();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarC,
        elevation: 2.0,
        shadowColor: appBarShadow,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        title: Text("Existing Customer Loan"),
        titleTextStyle: TextStyle(
          color: btnC,
          fontSize: appBarFontS,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: ValueListenableBuilder<bool>(
              valueListenable: CheckConnection.isOnline,
              builder: (context, online, child) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      CheckConnection.initialize();
                    });

                    showTopNotification(
                      context,
                      online ? "Device is Online" : "Device is Offline",
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: online
                          ? const Color.fromARGB(40, 9, 172, 58)
                          : const Color.fromARGB(40, 172, 9, 9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: online
                            ? const Color.fromARGB(255, 9, 172, 58)
                            : const Color.fromARGB(255, 172, 9, 9),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      online ? "ONLINE" : "OFFLINE",
                      style: TextStyle(
                        color: online
                            ? const Color.fromARGB(255, 9, 172, 58)
                            : const Color.fromARGB(255, 172, 9, 9),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: safeAreaC,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: safeAreaHorizontalPD,
              vertical: safeAreaVerticalPD,
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Customer"),
                  ElevatedButton(
                    onPressed: () {
                      databaseService.deleteAllData("employees");
                      databaseService.deleteAllData("customers");
                      databaseService.deleteAllData("installments");
                      databaseService.deleteAllData("interest_rates");
                      databaseService.deleteAllData("loans");
                    },
                    child: const Text("delete all table data"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      databaseService.getAllTableData("employees");
                      databaseService.getAllTableData("customers");
                      databaseService.getAllTableData("installments");
                      databaseService.getAllTableData("interest_rates");
                      databaseService.getAllTableData("loans");
                    },
                    child: const Text("print Table Data"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SyncAsyncView(),
                        ),
                      );
                    },
                    child: const Text("Sync method"),
                  ),
                  Text("Lons"),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("delete all Loans"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("print Loans"),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: const Text("drop table"),
                  // ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("print all data in database"),
                  ),
                  SizedBox(height: 20),
                  Text("Database"),
                  OutlinedButton(
                    onPressed: () {
                      databaseService.printAllTables();
                    },
                    child: const Text("Print all tables"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      asyncDatabaseTable.customersTable(context);
                      asyncDatabaseTable.employeesTable(context);
                      asyncDatabaseTable.installmentsTable(context);
                    },
                    child: const Text("Sync"),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      databaseService.dropTables();
                    },
                    child: const Text("delete all tables"),
                  ),
                  SizedBox(height: 40),
                  OutlinedButton(
                    onPressed: () {
                      databaseService.printAllTables();
                      databaseService.dropTables();
                      databaseService.deleteDatabaseFile();
                      databaseService.close();
                    },
                    child: const Text("drop database"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
