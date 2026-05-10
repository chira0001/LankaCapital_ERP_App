import 'dart:io';

Future<bool> hasInternet() async {
  try {

    final result = await InternetAddress.lookup(
      'one.one.one.one',
    ).timeout(const Duration(seconds: 3));

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  } catch (_) {
    return false;
  }
}
