import 'dart:io';

import 'package:cammate/config/api_endpoints.dart';
import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/networking/http_service.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/auth/data/dto/get_user_details.dart';
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
      var response = await dio.post(
        ApiEndpoints.register,
        data: authAPIModel.toJson(),
      );
      if (response.statusCode == 200) {
        String message = response.data['message'];
        return Right(message);
      } else {
        return Left(
          Failure(
            error: response.data['data']['error'],
            statusCode: response.data['status'],
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.data['status'] ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, String>> verifyEmail(String email, String otp) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.verifyEmail,
        data: {"email": email, "otp": otp},
      );
      if (response.statusCode == 200) {
        String message = response.data['message'];
        return Right(message);
      } else {
        return Left(
          Failure(
            error: response.data['data']['error'],
            statusCode: response.data['status'],
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.data['status'] ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      var data = {"email": email, "password": password};
      print('LOGIN DATA:: $data');
      Response response = await dio.post(
        ApiEndpoints.login,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('RESPONSE::: ${response.data}');
      if (response.data['status'] == 200) {
        String token = response.data['access'];
        String message = response.data['data']['message'];
        userSharedPrefs.setUserToken(token);
        return Right(message);
      } else {
        print('DIO FAILURE:: ${response.data['data']['error']}');
        var error = response.data['data']['error'];
        print('ELSE ERROR:: $error');
        return Left(
          Failure(
            error: response.data['data']['error'],
            statusCode: response.data['status'],
          ),
        );
      }
    } on DioException catch (e) {
      print('DIO EXCEPTIONN:: $e');
      return Left(
        Failure(
          error: 'DATA SOURCE EXCEPTION ${e.error.toString()}',
          statusCode: e.response?.data['status'] ?? 0,
        ),
      );
    }
  }

  Future<Either<Failure, String>> updateUser(
    String fullName,
    String email,
    String address,
    String number,
  ) async {
    try {
      final userData = await userSharedPrefs.getUser();
      String? id = userData?['_id']?.toString() ?? '';
      var response = await dio.put(
        ApiEndpoints.updateUser + id,
        data: {
          "fullName": fullName,
          "email": email,
          "address": address,
          "number": number,
        },
      );

      if (response.statusCode == 200) {
        String message = response.data['message'];
        return Right(message);
      } else {
        return Left(
          Failure(
            error: response.data['data']['error'],
            statusCode: response.data['status'],
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.data['status'] ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, String>> updateUserPassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final userData = await userSharedPrefs.getUser();
      String? id = userData?['_id']?.toString() ?? '';
      var response = await dio.put(
        ApiEndpoints.editUserPassword + id,
        data: {"currentPassword": currentPassword, "newPassword": newPassword},
      );

      if (response.statusCode == 200) {
        String message = response.data['message'];
        return Right(message);
      } else {
        return Left(
          Failure(
            error: response.data['data']['error'],
            statusCode: response.data['status'],
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.data['status'] ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, String>> uploadProfilePicture(File? image) async {
    try {
      if (image == null) {
        return Left(Failure(error: "Image file is null"));
      }

      final userData = await userSharedPrefs.getUser();
      String? id = userData?['_id']?.toString() ?? '';
      FormData formData = FormData.fromMap({
        'userImage': await MultipartFile.fromFile(image.path),
      });

      Response response = await dio.put(
        ApiEndpoints.uploadProfileImage + id,
        data: formData,
      );
      if (response.statusCode == 200) {
        String message = response.data['message'];
        return Right(message);
      } else {
        return Left(
          Failure(
            error: response.data['data']['error'],
            statusCode: response.data['status'],
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.data['status'] ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, String>> requestOTP(String email) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.requestOTP,
        data: {"email": email},
      );
      if (response.statusCode == 200) {
        String message = response.data['message'];
        return Right(message);
      } else {
        return Left(
          Failure(
            error: response.data['data']['error'],
            statusCode: response.data['status'],
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.data['status'] ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, String>> resetPassword(
    String email,
    String otp,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.resetPassword,
        data: {"email": email, "otp": otp, "newPassword": password},
      );
      if (response.statusCode == 200) {
        String message = response.data['message'];
        return Right(message);
      } else {
        return Left(
          Failure(
            error: response.data['data']['error'],
            statusCode: response.data['status'],
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.data['status'] ?? '0',
        ),
      );
    }
  }

  Future<AuthEntity> getUserById() async {
    try {
      final userData = await userSharedPrefs.getUser();
      String? id = userData?['_id']?.toString() ?? '';

      final response = await dio.get(ApiEndpoints.getUserById + id);

      if (response.statusCode == 200) {
        final getUserDetailDTO = GetUserDetailDTO.fromJson(response.data);

        final userDetail = getUserDetailDTO.userDetail;
        return userDetail;
      } else {
        throw Failure(
          error: response.data['data']['error'] ?? 'Unknown error',
          statusCode: response.data['status'],
        );
      }
    } on DioException catch (e) {
      throw Failure(
        error: e.error.toString(),
        statusCode: e.response?.data['status'] ?? '0',
      );
    }
  }
}
