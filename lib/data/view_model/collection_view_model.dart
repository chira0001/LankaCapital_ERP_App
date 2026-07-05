// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/collection_service.dart';
import 'package:nkrs_app/data/services/database_service/database_put_service.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/models/collections_model.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class CollectionViewModel {
// int? c = await DatabaseUserService().getTempUserId();
  Future<bool> addCollection(CollectionsModel collection, BuildContext context) async {
    try {
      String? m;
      if (CheckConnection.isOnline.value) {
        m = await CollectionService().addCollectionToServer(collection);
        if (m == null) {
          ScaffoldMessageBottom.show(context, "Server Connection failed");
          return false;
        }
      } else {
        m = await DatabasePutService().insertCollectionLocal(collection);
        if (m == null) {
          ScaffoldMessageBottom.show(context, "Database Connection failed");
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
