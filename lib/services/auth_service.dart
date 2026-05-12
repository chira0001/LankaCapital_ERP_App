import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  late final Dio _dio;
  final String _tokenKey = 'jwt_token';
  final String _refreshTokenKey = 'refresh_token';
  final String _baseUrl = 'http://10.16.54.234:8080/api/v1';

  AuthService() {
    // 1. Initialize Dio with base configurations
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    // 2. Add an Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await getToken();
          if (token != null) {
            try {
              if (JwtDecoder.isExpired(token)) {
                token = await refreshJwtToken(token);
              }
            } catch (e) {
              // If decoding fails, try to refresh
              token = await refreshJwtToken(token);
            }
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await logout();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<String?> refreshJwtToken(String? currentToken) async {
    try {
      final dioRefresh = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

      String? tokenToRefresh = await _storage.read(key: _refreshTokenKey);
      if (tokenToRefresh == null) {
        tokenToRefresh = currentToken;
      }

      if (tokenToRefresh == null) return null;

      final response = await dioRefresh.post(
        '/auth/refresh',
        data: {'token': tokenToRefresh},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        final newRefreshToken = response.data['refreshToken'];

        if (newToken != null) {
          await setToken(newToken);
          if (newRefreshToken != null) {
            await _storage.write(key: _refreshTokenKey, value: newRefreshToken);
          }
          return newToken;
        }
      }
    } catch (e) {
      print("Failed to refresh token: $e");
      await logout();
    }
    return null;
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final refreshToken = response.data['refreshToken'];
        if (token != null) {
          try {
            await _storage.write(key: _tokenKey, value: token);
            if (refreshToken != null) {
              await _storage.write(key: _refreshTokenKey, value: refreshToken);
            }
          } catch (e) {
            print("Error writing token: $e");
          }
          return true;
        }
      }
    } on DioException catch (e) {
      print("Login failed: ${e.response?.statusCode} - ${e.message}");
    }
    return false;
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      print("Error reading token: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
    } catch (e) {
      print("Error deleting token: $e");
    }
  }

  Future<void> setToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      print("Error setting token: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<String?> getUserIdFromToken() async {
    final token = await getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      // Usually, the subject ('sub') contains the username or ID.
      return decodedToken['sub']?.toString();
    }
    return null;
  }

  Future<String?> getUserName() async {
    try {
      final profile = await getCustomerProfile();
      if (profile != null) {
        final firstName = profile['firstName'] ?? '';
        final fullName = "$firstName".trim();
        return fullName.isNotEmpty ? fullName : null;
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCustomerProfile() async {
    try {
      final token = await getToken();
      if (token != null) {
        print("Decoded JWT: ${JwtDecoder.decode(token)}");
      }

      final userId = await getUserIdFromToken();
      print("Extracted userId from token: $userId");
      if (userId == null) return null;

      print("Fetching all employees from: /recep/employees");
      final response = await _dio.get('/recep/employees');
      print("Profile response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> employees = response.data;
        for (var emp in employees) {
          if (emp['email'] == userId) {
            print("Found matching employee profile: $emp");
            return emp;
          }
        }
        print("Employee with email $userId not found in the list.");
      }
    } on DioException catch (e) {
      print(
        "Dio Error fetching profile: ${e.response?.statusCode} - ${e.response?.data}",
      );
    } catch (e) {
      print("Error fetching profile: $e");
    }
    return null;
  }

  Future<bool> updateCustomerProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      // Changed to /recep/employees/{email} to match the employee update endpoint
      final response = await _dio.put('/recep/employees/$userId', data: data);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }

  // Expose dio so we can use it in other places if needed
  Dio get dio => _dio;
}
