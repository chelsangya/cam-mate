import 'package:cammate/config/api_endpoints.dart';
import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/networking/http_service.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/auth/data/model/auth_model.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        userSharedPrefs.setUserToken(token);
        userSharedPrefs.setUser({'username': username, 'password': password});

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
    newPassword,
  ) async {
    try {
      // POST request with current and new passwords as query parameters
      Response response = await dio.post(
        ApiEndpoints.changePassword,
        queryParameters: {"current_password": currentPassword, "new_password": newPassword},
        options: Options(headers: {'accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data =
            response.data is Map
                ? Map<String, dynamic>.from(response.data)
                : {'message': response.data.toString()};
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
      return Left(
        Failure(
          error: e.response?.data['detail']?.toString() ?? e.error.toString(),
          statusCode: e.response?.statusCode ?? 0,
        ),
      );
    }
  }

  // Future<Either<Failure, String>> uploadProfilePicture(File? image) async {
  //   try {
  //     if (image == null) {
  //       return Left(Failure(error: "Image file is null"));
  //     }

  //     final userData = await userSharedPrefs.getUser();
  //     String? id = userData?['_id']?.toString() ?? '';
  //     FormData formData = FormData.fromMap({'userImage': await MultipartFile.fromFile(image.path)});

  //     Response response = await dio.put(ApiEndpoints.uploadProfileImage + id, data: formData);
  //     if (response.data['status'] == 200) {
  //       String message = response.data['data']['message'];
  //       return Right(message);
  //     } else {
  //       return Left(
  //         Failure(error: response.data['data']['error'], statusCode: response.data['status']),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     return Left(
  //       Failure(error: e.error.toString(), statusCode: e.response?.data['status'] ?? '0'),
  //     );
  //   }
  // }

  // Future<Either<Failure, String>> requestOTP(String username) async {
  //   try {
  //     Response response = await dio.post(
  //       ApiEndpoints.requestOTP,
  //       data: {"username": username},
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

  /// Reset password using a token (query parameter: token, new_password)
  Future<Either<Failure, String>> resetPasswordWithToken(String token, String newPassword) async {
    try {
      // Some backends expect token and new_password as query parameters (see API docs).
      Response response = await dio.post(
        ApiEndpoints.resetPassword,
        queryParameters: {"token": token, "new_password": newPassword},
        options: Options(headers: {'accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // many endpoints return { "message": "..." }
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

  // Future<AuthEntity> getUserById() async {
  //   try {
  //     final userData = await userSharedPrefs.getUser();
  //     String? id = userData?['_id']?.toString() ?? '';

  //     final response = await dio.get(ApiEndpoints.getUserById + id);

  //     if (response.data['status'] == 200) {
  //       final getUserDetailDTO = GetUserDetailDTO.fromJson(response.data);

  //       final userDetail = getUserDetailDTO.userDetail;
  //       return userDetail;
  //     } else {
  //       throw Failure(
  //         error: response.data['data']['error'] ?? 'Unknown error',
  //         statusCode: response.data['status'],
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw Failure(
  //       error: e.error.toString(),
  //       statusCode: e.response?.data['status'] ?? '0',
  //     );
  //   }
  // }
}
