import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/models/user_model.dart';

class UserRepository {
  final UserService _service = UserService();
  late User _user;
  User get user => _user;

  
}
