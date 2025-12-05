import 'package:cammate/config/api_endpoints.dart';
import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/networking/http_service.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/auth/data/model/auth_model.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final authRemoteDataSourceProvider = Provider.autoDispose<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;
  UserSharedPrefs userSharedPrefs;

  AuthRemoteDataSource({required this.dio, required this.userSharedPrefs});

  Future<Either<Failure, String>> _getValidToken() async {
    final tokenEither = await userSharedPrefs.getUserToken();
    String? token = tokenEither.fold((_) => null, (t) => t);

    if (token == null || token.isEmpty) {
      return Left(Failure(error: 'User is not authenticated', statusCode: 401));
    }

    if (JwtDecoder.isExpired(token)) {
      final refreshResult = await _refreshToken(token);
      if (refreshResult.isLeft()) {
        print('Token refresh failed inside datasource auth $refreshResult');
        return Left(Failure(error: 'Token expired and refresh failed', statusCode: 401));
      } else {
        token = refreshResult.getOrElse(() => '');
      }
    }

    return Right(token);
  }

  Future<Either<Failure, String>> _refreshToken(String expiredToken) async {
    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {"refresh_token": expiredToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final newToken = response.data['access_token'] as String?;
        if (newToken == null || newToken.isEmpty) {
          return Left(Failure(error: 'Empty token received during refresh', statusCode: 400));
        }

        await userSharedPrefs.setUserToken(newToken);
        return Right(newToken);
      } else if (response.statusCode == 403) {
        // Token is invalid or expired, clear it
        await userSharedPrefs.deleteUserToken();
        return Left(
          Failure(error: 'Refresh token expired or invalid. Please log in again.', statusCode: 403),
        );
      } else {
        final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
        return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
      }
    } catch (e) {
      print('Error during token refresh: $e');
      return Left(Failure(error: e.toString(), statusCode: 500));
    }
  }

  Future<Either<Failure, String>> registerUser(AuthEntity auth) async {
    try {
      AuthAPIModel authAPIModel = AuthAPIModel.fromEntity(auth);
      var response = await dio.post(ApiEndpoints.createUser, data: authAPIModel.toJson());
      if (response.data['status'] == 200) {
        String message = response.data['data']['message'];
        return Right(message);
      } else {
        return Left(
          Failure(error: response.data['data']['error'], statusCode: response.data['status']),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(error: e.error.toString(), statusCode: e.response?.data['status'] ?? '0'),
      );
    }
  }

  // Future<Either<Failure, String>> verifyEmail(String username, String otp) async {
  //   try {
  //     Response response = await dio.post(
  //       ApiEndpoints.verifyEmail,
  //       data: {"username": username, "otp": otp},
  //     );
  //     if (response.data['status'] == 200) {
  //       String message = response.data['data']['message'];
  //       return Right(message);
  //     } else {
  //       return Left(
  //         Failure(
  //           error: response.data['data']['error'],
  //           statusCode: response.data['status'],
  //         ),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     return Left(
  //       Failure(
  //         error: e.error.toString(),
  //         statusCode: e.response?.data['status'] ?? '0',
  //       ),
  //     );
  //   }
  // }

  Future<Either<Failure, String>> loginUser(String username, String password) async {
    try {
      var formData = FormData.fromMap({
        'grant_type': '',
        'username': username,
        'password': password,
        'scope': '',
        'client_id': '',
        'client_secret': '',
      });

      print('LOGIN FORM DATA:: $formData');

      Response response = await dio.post(
        ApiEndpoints.login,
        data: formData,
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      if (response.statusCode == 200) {
        // The backend only returns token info
        String token = response.data['access_token'];
        String role = response.data['role'].toLowerCase();
        String firstName = response.data['first_name'];
        String lastName = response.data['last_name'];
        String uid = response.data['uid'];

        userSharedPrefs.setUserToken(token);
        final user = {
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'uid': uid,
        };
        userSharedPrefs.setUserRole(role);
        userSharedPrefs.setUser(user);

        return Right('Login successful');
      } else {
        return Left(
          Failure(
            error: response.data['detail']?.toString() ?? 'Unknown error',
            statusCode: response.statusCode ?? 0,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.error.toString(), statusCode: e.response?.statusCode ?? 0));
    }
  }

  // Future<Either<Failure, String>> updateUser(
  //   String fullName,
  //   String username,
  //   String address,
  //   String number,
  // ) async {
  //   try {
  //     final userData = await userSharedPrefs.getUser();
  //     String? id = userData?['_id']?.toString() ?? '';
  //     var response = await dio.put(
  //       ApiEndpoints.updateUser + id,
  //       data: {
  //         "fullName": fullName,
  //         "username": username,
  //         "address": address,
  //         "number": number,
  //       },
  //     );

  //     if (response.data['status'] == 200) {
  //       String message = response.data['data']['message'];
  //       return Right(message);
  //     } else {
  //       return Left(
  //         Failure(
  //           error: response.data['data']['error'],
  //           statusCode: response.data['status'],
  //         ),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     return Left(
  //       Failure(
  //         error: e.error.toString(),
  //         statusCode: e.response?.data['status'] ?? '0',
  //       ),
  //     );
  //   }
  // }

  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(String email) async {
    try {
      // Make POST request with email as query parameter
      Response response = await dio.post(
        ApiEndpoints.forgotPassword,
        queryParameters: {"email": email},
        options: Options(headers: {'accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // Return the full response map so callers can access message and optional reset_token
        final respMap =
            response.data is Map
                ? Map<String, dynamic>.from(response.data)
                : {'message': response.data.toString()};
        // ensure a consistent success flag and preserve reset_token if present
        final data = <String, dynamic>{
          'message': respMap['message'] ?? respMap['data']?['message'] ?? respMap.toString(),
          'success': true,
        };
        if (respMap.containsKey('reset_token')) data['reset_token'] = respMap['reset_token'];
        return Right(data);
      } else {
        return Left(
          Failure(
            error: response.data['detail']?.toString() ?? 'Unknown error',
            statusCode: response.statusCode ?? 0,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.error.toString(), statusCode: e.response?.statusCode ?? 0));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      // Get the user token
      final tokenResult = await _getValidToken();

      return await tokenResult.fold((failure) => Left(failure), (token) async {
        if (token.isEmpty) {
          return Left(Failure(error: 'Token not available', statusCode: 401));
        }

        // Make POST request with query parameters
        final response = await dio.post(
          ApiEndpoints.changePassword,
          queryParameters: {"current_password": currentPassword, "new_password": newPassword},
          options: Options(
            headers: {"accept": "application/json", "Authorization": "Bearer $token"},
          ),
        );

        if (response.statusCode == 200) {
          final data =
              response.data is Map
                  ? Map<String, dynamic>.from(response.data)
                  : {"message": response.data.toString()};
          return Right(data);
        } else if (response.statusCode == 422) {
          final errorMsg =
              response.data['detail'] != null
                  ? response.data['detail'].toString()
                  : 'Validation error';
          return Left(Failure(error: errorMsg, statusCode: 422));
        } else {
          return Left(
            Failure(
              error: response.data['detail']?.toString() ?? 'Unknown error',
              statusCode: response.statusCode ?? 0,
            ),
          );
        }
      });
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
  }

  Future<Either<Failure, String>> resetPassword(
    String username,
    String otp,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.resetPassword,
        data: {"username": username, "otp": otp, "newPassword": password},
      );
      if (response.data['status'] == 200) {
        String message = response.data['data']['message'];
        return Right(message);
      } else {
        return Left(
          Failure(error: response.data['data']['error'], statusCode: response.data['status']),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(error: e.error.toString(), statusCode: e.response?.data['status'] ?? '0'),
      );
    }
  }

  Future<Either<Failure, String>> resetPasswordWithToken(String token, String newPassword) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.resetPassword,
        queryParameters: {"token": token, "new_password": newPassword},
        options: Options(headers: {'accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        String message =
            response.data['message'] ??
            response.data['data']?['message'] ??
            'Password reset successful';
        return Right(message);
      } else {
        return Left(
          Failure(
            error:
                response.data['detail']?.toString() ??
                response.data['data']?['error']?.toString() ??
                'Unknown error',
            statusCode: response.statusCode ?? 0,
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.error.toString(), statusCode: e.response?.statusCode ?? 0));
    }
  }
}
