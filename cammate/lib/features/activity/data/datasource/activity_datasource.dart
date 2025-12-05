import 'package:cammate/config/api_endpoints.dart';
import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/networking/http_service.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/activity/data/model/activity_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final activityRemoteDataSourceProvider = Provider.autoDispose<ActivityRemoteDataSource>(
  (ref) => ActivityRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class ActivityRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  ActivityRemoteDataSource({required this.dio, required this.userSharedPrefs});

  Future<Either<Failure, String>> _getValidToken() async {
    final tokenEither = await userSharedPrefs.getUserToken();
    String? token = tokenEither.fold((_) => null, (t) => t);

    if (token == null || token.isEmpty) {
      return Left(Failure(error: 'User is not authenticated', statusCode: 401));
    }

    if (JwtDecoder.isExpired(token)) {
      final refreshResult = await _refreshToken(token);
      if (refreshResult.isLeft()) {
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
      } else {
        final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
        return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
      }
    } catch (e) {
      return Left(Failure(error: e.toString(), statusCode: 500));
    }
  }

  Future<Either<Failure, List<ActivityAPIModel>>> getActivities({
    int? martId,
    String? status,
    String? priority,
    int skip = 0,
    int limit = 100,
  }) async {
    final tokenResult = await _getValidToken();

    return await tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.get(
          ApiEndpoints.getActivities,
          queryParameters: {
            if (martId != null) 'mart_id': martId,
            if (status != null) 'status': status,
            if (priority != null) 'priority': priority,
            'skip': skip,
            'limit': limit,
          },
          options: Options(
            headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
          ),
        );

        if (response.statusCode == 200 && response.data is List) {
          final activities =
              (response.data as List)
                  .map(
                    (json) => ActivityAPIModel.fromJson(
                      (json as Map).map((k, v) => MapEntry(k.toString(), v)),
                    ),
                  )
                  .toList();
          return Right(activities);
        } else {
          final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
          return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
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

  Future<Either<Failure, ActivityAPIModel>> createActivity({
    required int cameraId,
    required String activityType,
    required String description,
    required double confidence,
    String? status,
    String? videoClip,
    String? imageUrl,
    String? assignedTo,
    String? priority,
  }) async {
    final tokenResult = await _getValidToken();
    return await tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        print('Creating activity with cameraId: $cameraId, activityType: $activityType');
        final response = await dio.post(
          ApiEndpoints.createActivity,
          data: {
            'camera_id': cameraId,
            'activity_type': activityType,
            'description': description,
            'confidence': confidence,
            if (status != null) 'status': status,
            if (videoClip != null) 'video_clip': videoClip,
            if (imageUrl != null) 'image_url': imageUrl,
            if (assignedTo != null) 'assigned_to': assignedTo,
            if (priority != null) 'priority': priority,
          },
          options: Options(
            headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
          ),
        );
        print('Response status: ${response.statusCode}, data: ${response.data}');

        if (response.statusCode == 201) {
          final data = (response.data as Map).map((k, v) => MapEntry(k.toString(), v));
          return Right(ActivityAPIModel.fromJson(data));
        } else {
          final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
          return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
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

  Future<Either<Failure, String>> getActivityStats({required int martId}) async {
    final tokenResult = await _getValidToken();
    return await tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.get(
          ApiEndpoints.activityStats,
          queryParameters: {'mart_id': martId},
          options: Options(
            headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
          ),
        );

        if (response.statusCode == 200) {
          return Right(response.data.toString());
        } else {
          final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
          return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
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

  Future<Either<Failure, ActivityAPIModel>> getActivityById(int activityId) async {
    final tokenResult = await _getValidToken();
    return await tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.get(
          ApiEndpoints.getActivity(activityId.toString()),
          options: Options(
            headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
          ),
        );

        if (response.statusCode == 200) {
          final data = (response.data as Map).map((k, v) => MapEntry(k.toString(), v));
          return Right(ActivityAPIModel.fromJson(data));
        } else {
          final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
          return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
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

  Future<Either<Failure, ActivityAPIModel>> updateActivity(
    int activityId, {
    String? description,
    String? status,
    String? assignedTo,
    String? priority,
  }) async {
    final tokenResult = await _getValidToken();
    return await tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final body = <String, dynamic>{};
        if (description != null) body['description'] = description;
        if (status != null) body['status'] = status;
        if (assignedTo != null) body['assigned_to'] = assignedTo;
        if (priority != null) body['priority'] = priority;

        final response = await dio.put(
          ApiEndpoints.updateActivity(activityId.toString()),
          data: body,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          final data = (response.data as Map).map((k, v) => MapEntry(k.toString(), v));
          return Right(ActivityAPIModel.fromJson(data));
        } else {
          final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
          return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
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

  Future<Either<Failure, String>> deleteActivity(int activityId) async {
    final tokenResult = await _getValidToken();
    return await tokenResult.fold((failure) => Left(failure), (token) async {
      try {
        final response = await dio.delete(
          ApiEndpoints.deleteActivity(activityId.toString()),
          options: Options(
            headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
          ),
        );

        if (response.statusCode == 200) {
          final message =
              response.data is String
                  ? response.data
                  : response.data['message']?.toString() ?? 'Activity deleted successfully';
          return Right(message);
        } else {
          final errorMsg = response.data['detail']?.toString() ?? 'Unknown error';
          return Left(Failure(error: errorMsg, statusCode: response.statusCode ?? 0));
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
}
