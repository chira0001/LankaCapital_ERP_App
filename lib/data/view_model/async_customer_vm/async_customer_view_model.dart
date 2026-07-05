// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/async_service/async_customer/async_customer_service.dart';
import 'package:nkrs_app/data/services/async_service/async_customer/async_database_customer.dart';
import 'package:nkrs_app/models/async_manage_model/manage_customer_model.dart';
import 'package:nkrs_app/models/update_model/customer_update.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class AsyncCustomerViewModel {
  final AsyncCustomerService _asyncCustomerService = AsyncCustomerService();
  final AsyncDatabaseCustomer _asyncDatabaseCustomer = AsyncDatabaseCustomer();

  final int limit = 10;

  Future<bool?> ManageCustomersTabel(BuildContext context) async {
    int pageNo = 0;
    await _asyncDatabaseCustomer.clearTempCustomers();
    await _asyncDatabaseCustomer.clearUpdateCustomers();

    while (true) {
      //async
      List<ManageCustomerModel>? serverData = await _asyncCustomerService
          .manageCustomers(pageNo);

      if (serverData == null) return false;
      if (serverData.isEmpty) {
        break;
      }

      bool? table = await _asyncDatabaseCustomer.insertTempCustomers(
        serverData,
      );
      if (table == null) {
        await _asyncDatabaseCustomer.clearTempCustomers();
        await _asyncDatabaseCustomer.clearUpdateCustomers();
        break;
      }
      ++pageNo;
    }

    int offset = 0;
    while (true) {
      //
      final customerIds = await _asyncDatabaseCustomer.getCustomersIds(
        limit: limit,
        offset: offset,
      );
      if (customerIds.isEmpty) {
        break;
      }
      Map<String, dynamic> json = {"nic": customerIds};
      List<CustomerUpdate>? tableData = await _asyncCustomerService
          .asyncCustomers(json);
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

      for (var customer in tableData) {
        customer.sync = 2;
      }

      for (var item in tableData) {
        final savedId = (await _asyncDatabaseCustomer.insertCustomerToTable(
          item,
        ));
        if (savedId == null) {
          ScaffoldMessageBottom.show(context, "Can't insert data Customers");
          return false;
        }
      }
      offset += limit;
    }

    int offsets = 0; //update
    while (true) {
      final customerIds = await _asyncDatabaseCustomer.getUpdateCustomers(
        limit: limit,
        offset: offsets,
      );

      if (customerIds.isEmpty) {
        break;
      }
      Map<String, dynamic> json = {"nic": customerIds};
      List<CustomerUpdate>? tableData = await _asyncCustomerService
          .asyncCustomers(json);
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
        final savedId = (await _asyncDatabaseCustomer.updateCustomerToTable(
          item,
        ));
        if (savedId == null) {
          ScaffoldMessageBottom.show(context, "Can't insert data Customers");
          return false;
        }
      }
      offsets += limit;
    }

    await _asyncDatabaseCustomer.deleteCustomers();
    await _asyncDatabaseCustomer.resetCustomers();
    await _asyncDatabaseCustomer.clearTempCustomers();
    await _asyncDatabaseCustomer.clearUpdateCustomers();
    return true;
  }
}
