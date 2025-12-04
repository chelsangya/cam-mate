import 'package:cammate/config/api_endpoints.dart';
import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/networking/http_service.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/mart/data/model/mart_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final martRemoteDataSourceProvider = Provider.autoDispose<MartRemoteDataSource>(
  (ref) => MartRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class MartRemoteDataSource {
  final Dio dio;
  UserSharedPrefs userSharedPrefs;

  MartRemoteDataSource({required this.dio, required this.userSharedPrefs});

  /// Helper: Get valid token (refresh if expired)
  Future<Either<Failure, String>> _getValidToken() async {
    final tokenEither = await userSharedPrefs.getUserToken();
    String? token = tokenEither.fold((_) => null, (t) => t);

    if (token == null || token.isEmpty) {
      return Left(Failure(error: 'User is not authenticated', statusCode: 401));
    }

    if (JwtDecoder.isExpired(token)) {
      // Try to refresh token
      final refreshResult = await _refreshToken(token);
      if (refreshResult.isLeft()) {
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
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {"refresh_token": expiredToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        final newToken = response.data['access_token'] as String;
        await userSharedPrefs.setUserToken(newToken);
        return Right(newToken);
      }

      return Left(Failure(error: 'Token refresh failed', statusCode: response.statusCode ?? 0));
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  /// Create a new Mart
  Future<Either<Failure, MartAPIModel>> createMart(MartAPIModel mart) async {
    final tokenResult = await _getValidToken();
    return tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.post(
          ApiEndpoints.createMart,
          data: mart.toJson(),
          options: Options(
            headers: {
              "accept": "application/json",
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );

        if (response.statusCode == 201) {
          return Right(MartAPIModel.fromJson(response.data as Map<String, dynamic>));
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
    });
  }

  /// Get all Marts
  Future<Either<Failure, List<MartAPIModel>>> getAllMarts({int skip = 0, int limit = 100}) async {
    final tokenResult = await _getValidToken();
    return tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.get(
          ApiEndpoints.getMarts,
          queryParameters: {'skip': skip, 'limit': limit},
          options: Options(
            headers: {"accept": "application/json", "Authorization": "Bearer $token"},
          ),
        );

        if (response.statusCode == 200) {
          final List data = response.data as List;
          final marts = data.map((json) => MartAPIModel.fromJson(json)).toList();
          return Right(marts);
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
    });
  }

  /// Get Mart by ID
  Future<Either<Failure, MartAPIModel>> getMartById(int martId) async {
    final tokenResult = await _getValidToken();
    return tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.get(
          '${ApiEndpoints.getMart}/$martId',
          options: Options(
            headers: {"accept": "application/json", "Authorization": "Bearer $token"},
          ),
        );

        if (response.statusCode == 200) {
          return Right(MartAPIModel.fromJson(response.data as Map<String, dynamic>));
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
    });
  }

  /// Update Mart
  Future<Either<Failure, MartAPIModel>> updateMart(int martId, MartAPIModel mart) async {
    print('Attempting to update mart with ID: $martId');

    final tokenResult = await _getValidToken();

    return await tokenResult.fold((failure) => Left(failure), (token) async {
      if (token.isEmpty) {
        return Left(Failure(error: 'Token not available', statusCode: 401));
      }

      try {
        final response = await dio.put(
          ApiEndpoints.updateMart(martId.toString()), // Use the correct endpoint function
          data: mart.toJson(),
          options: Options(
            headers: {
              "accept": "application/json",
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );

        print('Response status code: ${response.statusCode}');

        if (response.statusCode == 200) {
          final updatedMart = MartAPIModel.fromJson(response.data as Map<String, dynamic>);
          return Right(updatedMart);
        } else {
          return Left(
            Failure(
              error: response.data['detail']?.toString() ?? 'Unknown error',
              statusCode: response.statusCode ?? 0,
            ),
          );
        }
      } on DioException catch (e) {
        print('DioException caught: ${e.toString()}');
        return Left(
          Failure(
            error: e.response?.data?.toString() ?? e.message ?? 'Unknown Dio error',
            statusCode: e.response?.statusCode ?? 0,
          ),
        );
      } catch (e) {
        print('General exception caught: ${e.toString()}');
        return Left(Failure(error: e.toString(), statusCode: 0));
      }
    });
  }

  Future<Either<Failure, String>> deleteMart(int martId) async {
    print('Attempting to delete mart with ID: $martId');

    final tokenResult = await userSharedPrefs.getUserToken();

    return await tokenResult.fold((failure) => Left(failure), (token) async {
      if (token == null || token.isEmpty) {
        return Left(Failure(error: 'Token not available', statusCode: 401));
      }

      try {
        print('Using token: $token');

        final response = await dio.delete(
          ApiEndpoints.getMart(martId.toString()),
          options: Options(
            headers: {"accept": "application/json", "Authorization": "Bearer $token"},
          ),
        );

        print('Response status code: ${response.statusCode}');
        print('Response data: ${response.data}');

        if (response.statusCode == 200) {
          // API returns a string, not JSON
          return Right(response.data?.toString() ?? 'Deleted successfully');
        } else if (response.statusCode == 422) {
          final errorMsg =
              response.data is Map && response.data['detail'] != null
                  ? response.data['detail'].toString()
                  : 'Validation error';
          return Left(Failure(error: errorMsg, statusCode: 422));
        } else {
          final errorMsg =
              response.data is Map && response.data['detail'] != null
                  ? response.data['detail'].toString()
                  : 'Unknown error';
          return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
        }
      } on DioException catch (e) {
        print('DioException caught: ${e.toString()}');
        return Left(
          Failure(
            error: e.response?.data?.toString() ?? e.message as String,
            statusCode: e.response?.statusCode ?? 0,
          ),
        );
      } catch (e) {
        print('General exception caught: ${e.toString()}');
        return Left(Failure(error: e.toString(), statusCode: 0));
      }
    });
  }
}
