import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:nkrs_app/data/services/api_config.dart';

/// Thrown when a user successfully authenticates but does not have the
/// required role (e.g. not a Field Officer) to use this app.
class RoleNotAllowedException implements Exception {
  final String message;
  const RoleNotAllowedException([
    this.message = 'Access denied: Field Officers only.',
  ]);

  @override
  String toString() => message;
}

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );
  late final Dio _dio;
  final String _tokenKey = 'jwt_token';
  final String _refreshTokenKey = 'refresh_token';
  final String _baseUrl = ApiConfig.baseUrl;

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

  /// Returns `true` only when login succeeds AND the user has the "FO" role.
  /// Returns `false` otherwise (wrong credentials, network error, or wrong role).
  /// Throws a [RoleNotAllowedException] when the credentials are valid but
  /// the role is not "FO", so the caller can show a specific error message.
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
          // ── Role gate: only Field Officers (role == "FO") may enter ──
          try {
            final Map<String, dynamic> decoded = JwtDecoder.decode(token);
            // The role claim can arrive as a String or a List<dynamic>
            final dynamic roleClaim = decoded['role'] ?? decoded['roles'];
            bool isFO = false;
            if (roleClaim is String) {
              isFO = roleClaim == 'FO';
            } else if (roleClaim is List) {
              isFO = roleClaim.contains('FO');
            }

            if (!isFO) {
              // Valid credentials but wrong role — reject access
              debugPrint('Login blocked: role is "$roleClaim", expected "FO"');
              throw RoleNotAllowedException();
            }
          } on RoleNotAllowedException {
            rethrow; // propagate so the UI can show the right message
          } catch (e) {
            if (e is RoleNotAllowedException) rethrow;
            debugPrint('Could not decode token for role check: $e');
            // If decoding fails we cannot verify the role — deny access
            throw RoleNotAllowedException();
          }
          // ─────────────────────────────────────────────────────────────

          try {
            await _storage.write(key: _tokenKey, value: token);
            if (refreshToken != null) {
              await _storage.write(key: _refreshTokenKey, value: refreshToken);
            }
          } catch (e) {
            debugPrint('Error writing token: $e');
          }
          return true;
        }
      }
    } on RoleNotAllowedException {
      rethrow; // let login_page.dart handle this specifically
    } on DioException catch (e) {
      debugPrint('Login failed: ${e.response?.statusCode} - ${e.message}');
    }
    return false;
  }

  Future<bool> register({
    String? id,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'id': id,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioException catch (e) {
      debugPrint(
        "Registration failed: ${e.response?.statusCode} - ${e.response?.data}",
      );
      rethrow;
    } catch (e) {
      debugPrint("Registration error: $e");
      rethrow;
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
      await _storage.delete(key: 'cached_profile');
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
      final jwtToken = await getToken();
      if (jwtToken == null) return null;
      print('jwtToken---------------------------------------------: $jwtToken');
      final response = await _dio.get(
        '/field/employees/profile', // or your customer endpoint
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> profile = Map<String, dynamic>.from(
          response.data,
        );

        await _storage.write(key: 'cached_profile', value: jsonEncode(profile));

        return profile;
      }
    } catch (e) {
      debugPrint("Network error fetching profile: $e");

      final cached = await _storage.read(key: 'cached_profile');
      if (cached != null) {
        return Map<String, dynamic>.from(jsonDecode(cached));
      }
    }

    return null;
  }

  Future<bool> updateCustomerProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final jwtToken = await getToken();

      final response = await _dio.put(
        '/field/employees/profile', // or your customer endpoint
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Update cache
        final cachedStr = await _storage.read(key: 'cached_profile');
        if (cachedStr != null) {
          Map<String, dynamic> cached = jsonDecode(cachedStr);
          cached.addAll(data);
          await _storage.write(
            key: 'cached_profile',
            value: jsonEncode(cached),
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return false;
    }
  }

  Dio get dio => _dio;

  dynamic get currentUser => null;

  Future<(User, List<Loan>)> fetchCustomerAndLoans(int nic) async {
    try {
      final response = await _dio.get('/field/customers/$nic');

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
