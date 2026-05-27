import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );
  late final Dio _dio;
  final String _tokenKey = 'jwt_token';
  final String _refreshTokenKey = 'refresh_token';
  final String _baseUrl = 'http://10.230.135.234:8080/api/v1';

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
      tokenToRefresh ??= currentToken;

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
      debugPrint("Failed to refresh token: $e");
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
            debugPrint("Error writing token: $e");
          }
          return true;
        }
      }
    } on DioException catch (e) {
      debugPrint("Login failed: ${e.response?.statusCode} - ${e.message}");
    }
    return false;
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      debugPrint("Error reading token: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
    } catch (e) {
      debugPrint("Error deleting token: $e");
    }
  }

  Future<void> setToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      debugPrint("Error setting token: $e");
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
      debugPrint("Error fetching username: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCustomerProfile() async {
    try {
      final token = await getToken();
      if (token != null) {
        debugPrint("Decoded JWT: ${JwtDecoder.decode(token)}");
      }

      final userId = await getUserIdFromToken();
      debugPrint("Extracted userId from token: $userId");
      if (userId == null) return null;

      debugPrint("Fetching all employees from: /recep/employees");
      final response = await _dio.get('/recep/employees');
      debugPrint("Profile response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> employees = response.data;
        for (var emp in employees) {
          if (emp['email'] == userId) {
            debugPrint("Found matching employee profile: $emp");
            return emp;
          }
        }
        debugPrint("Employee with email $userId not found in the list.");
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio Error fetching profile: ${e.response?.statusCode} - ${e.response?.data}",
      );
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
    return null;
  }

  Future<bool> updateCustomerProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
     
      final response = await _dio.put('/recep/employees/$userId', data: data);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return false;
    }
  }

  Dio get dio => _dio;

  dynamic get currentUser => null;

  Future<(User, List<Loan>)> fetchCustomerAndLoans(int nic) async {
    try {
      final response = await _dio.get('/recep/customers/$nic');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        final user = User.fromJson(data);

        final rawLoans = data['loans'] as List<dynamic>? ?? [];
        final loans = rawLoans
            .map((json) => Loan.fromJson(json as Map<String, dynamic>))
            .toList();

        return (user, loans);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch customer data: ${e.response?.statusCode} - ${e.message}',
      );
    }
  }
}
