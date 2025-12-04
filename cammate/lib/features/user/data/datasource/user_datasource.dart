import 'package:cammate/config/api_endpoints.dart';
import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/networking/http_service.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/user/data/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final userRemoteDataSourceProvider = Provider.autoDispose<UserRemoteDataSource>(
  (ref) => UserRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class UserRemoteDataSource {
  final Dio dio;
  UserSharedPrefs userSharedPrefs;

  UserRemoteDataSource({required this.dio, required this.userSharedPrefs});

  /// Helper: Get valid token (refresh if expired)
  Future<Either<Failure, String>> _getValidToken() async {
    final tokenEither = await userSharedPrefs.getUserToken();
    String? token = tokenEither.fold((_) => null, (t) => t);

    if (token == null || token.isEmpty) {
      return Left(Failure(error: 'User is not authenticated', statusCode: 401));
    }

    if (JwtDecoder.isExpired(token)) {
      // Try to refresh token if expired
      final refreshResult = await _refreshToken(token);
      if (refreshResult.isLeft()) {
        print('Token refresh failed inside datasource user $refreshResult');
        return Left(Failure(error: 'Token expired and refresh failed', statusCode: 401));
      } else {
        token = refreshResult.getOrElse(() => '');
      }
    }

    return Right(token);
  }

  /// Refresh token
  Future<Either<Failure, String>> _refreshToken(String expiredToken) async {
    try {
      print('trying to refresh token');
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {"refresh_token": expiredToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('Refresh token response: ${response.data}');

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final newToken = response.data['access_token'] as String?;

        // Ensure the token is valid and not empty
        if (newToken == null || newToken.isEmpty) {
          return Left(Failure(error: 'Empty token received during refresh', statusCode: 400));
        }

        await userSharedPrefs.setUserToken(newToken);
        return Right(newToken);
      } else {
        final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
        return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
      }
    } catch (e) {
      print('Error during token refresh: $e');
      return Left(Failure(error: e.toString(), statusCode: 500));
    }
  }

  Future<Either<Failure, UserAPIModel>> createUser(UserAPIModel user, {String? password}) async {
    final tokenResult = await _getValidToken();

    return tokenResult.fold((failure) => Left(failure), (token) async {
      if (token.isEmpty) {
        return Left(Failure(error: 'Token not available', statusCode: 401));
      }

      try {
        final body = user.toBody(password: password);
        // Mask password for debug printing
        final maskedBody = Map<String, dynamic>.from(body);
        if (maskedBody.containsKey('password')) maskedBody['password'] = '***';
        if (kDebugMode) {
          // Print URL and masked body to help diagnose backend validation errors
          print('➡️ CreateUser POST ${ApiEndpoints.createUser}');
          print('➡️ Request body: $maskedBody');
        }

        final response = await dio.post(
          ApiEndpoints.createUser, // "/user/"
          data: body,
          options: Options(
            headers: {
              "accept": "application/json",
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );
        if (response.statusCode == 201) {
          final createdUser = UserAPIModel.fromJson(response.data as Map<String, dynamic>);
          return Right(createdUser);
        } else {
          // Try to extract any error detail, print debug info when available
          if (kDebugMode) {
            print(
              '⬅️ CreateUser response (${response.statusCode}) statusMessage: ${response.statusMessage}',
            );
            print('⬅️ Response headers: ${response.headers}');
            print('⬅️ Response data: ${response.data}');
          }
          final errorMsg =
              (response.data is Map && response.data['detail'] != null)
                  ? response.data['detail']?.toString()
                  : (response.data?.toString());
          return Left(
            Failure(error: errorMsg ?? 'Unknown error', statusCode: response.statusCode ?? 0),
          );
        }
      } on DioException catch (e) {
        if (kDebugMode) {
          print('⬅️ DioException in createUser: ${e.response?.statusCode} ${e.response?.data}');
          print('⬅️ DioException headers: ${e.response?.headers}');
        }
        return Left(
          Failure(
            error: e.response?.data?.toString() ?? e.message ?? 'Unknown Dio error',
            statusCode: e.response?.statusCode ?? 0,
          ),
        );
      } catch (e) {
        return Left(Failure(error: e.toString(), statusCode: 0));
      }
    });
  }

  /// Get all users (Superuser only)
  Future<Either<Failure, List<UserAPIModel>>> getAllUsers({int skip = 0, int limit = 100}) async {
    final tokenResult = await _getValidToken();

    return tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.get(
          ApiEndpoints.getUsers, // "/user/"
          queryParameters: {'skip': skip, 'limit': limit},
          options: Options(
            headers: {"accept": "application/json", "Authorization": "Bearer $token"},
          ),
        );

        if (response.statusCode == 200) {
          final List data = response.data as List;
          final users =
              data.map((json) => UserAPIModel.fromJson(json as Map<String, dynamic>)).toList();
          return Right(users);
        } else {
          return Left(
            Failure(
              error: response.data['detail']?.toString() ?? 'Unknown error',
              statusCode: response.statusCode ?? 0,
            ),
          );
        }
      } on DioException catch (e) {
        return Left(
          Failure(
            error: e.response?.data?.toString() ?? e.message ?? 'Unknown Dio error',
            statusCode: e.response?.statusCode ?? 0,
          ),
        );
      } catch (e) {
        return Left(Failure(error: e.toString(), statusCode: 0));
      }
    });
  }

  /// Get User by ID (Superuser only)
  Future<Either<Failure, UserAPIModel>> getUserById(int userId) async {
    final tokenResult = await _getValidToken();

    return tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.get(
          '${ApiEndpoints.getUsers}/$userId', // e.g. "/user/3"
          options: Options(
            headers: {"accept": "application/json", "Authorization": "Bearer $token"},
          ),
        );

        if (response.statusCode == 200) {
          return Right(UserAPIModel.fromJson(response.data as Map<String, dynamic>));
        } else {
          return Left(
            Failure(
              error: response.data['detail']?.toString() ?? 'Unknown error',
              statusCode: response.statusCode ?? 0,
            ),
          );
        }
      } on DioException catch (e) {
        return Left(
          Failure(
            error: e.response?.data?.toString() ?? e.message ?? 'Unknown Dio error',
            statusCode: e.response?.statusCode ?? 0,
          ),
        );
      } catch (e) {
        return Left(Failure(error: e.toString(), statusCode: 0));
      }
    });
  }

  /// Update User (Superuser only)
  Future<Either<Failure, UserAPIModel>> updateUser(
    int userId,
    UserAPIModel user, {
    String? password,
  }) async {
    final tokenResult = await _getValidToken();

    return await tokenResult.fold((failure) => Left(failure), (token) async {
      if (token.isEmpty) {
        return Left(Failure(error: "Token not available", statusCode: 401));
      }

      try {
        final body = {
          "email": user.email,
          "first_name": user.firstName,
          "last_name": user.lastName,
          "role": user.role,
          "is_active": user.isActive,
          "mart_id": user.martId,
          if (password != null) "password": password,
        };

        final response = await dio.put(
          '${ApiEndpoints.getUsers}/$userId',
          data: body,
          options: Options(
            headers: {
              "accept": "application/json",
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          return Right(UserAPIModel.fromJson(response.data as Map<String, dynamic>));
        } else {
          return Left(
            Failure(
              error: response.data['detail']?.toString() ?? 'Unknown error',
              statusCode: response.statusCode ?? 0,
            ),
          );
        }
      } on DioException catch (e) {
        return Left(
          Failure(
            error: e.response?.data?.toString() ?? e.message ?? "Unknown Dio error",
            statusCode: e.response?.statusCode ?? 0,
          ),
        );
      } catch (e) {
        return Left(Failure(error: e.toString(), statusCode: 0));
      }
    });
  }
}
