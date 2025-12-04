import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/activity/data/datasource/activity_datasource.dart';
import 'package:cammate/features/activity/data/model/activity_model.dart';
import 'package:cammate/features/activity/domain/repository/activity_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityRemoteRepoProvider = Provider.autoDispose<IActivityRepository>(
  (ref) => ActivityRemoteRepoImpl(
    activityRemoteDataSource: ref.read(activityRemoteDataSourceProvider),
  ),
);

class ActivityRemoteRepoImpl implements IActivityRepository {
  final ActivityRemoteDataSource activityRemoteDataSource;

  ActivityRemoteRepoImpl({required this.activityRemoteDataSource});

  @override
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
  }) {
    return activityRemoteDataSource.createActivity(
      cameraId: cameraId,
      activityType: activityType,
      description: description,
      confidence: confidence,
      status: status,
      videoClip: videoClip,
      imageUrl: imageUrl,
      assignedTo: assignedTo,
      priority: priority,
    );
  }


  @override
  Future<Either<Failure, List<ActivityAPIModel>>> getActivities({
    int? martId,
    String? status,
    String? priority,
    int skip = 0,
    int limit = 100,
  }) {
    return activityRemoteDataSource.getActivities(
      martId: martId,
      status: status,
      priority: priority,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<Either<Failure, ActivityAPIModel>> getActivityById(int activityId) {
    return activityRemoteDataSource.getActivityById(activityId);
  }

  @override
  Future<Either<Failure, String>> getActivityStats({required int martId}) {
    return activityRemoteDataSource.getActivityStats(martId: martId);
  }

  @override
  Future<Either<Failure, ActivityAPIModel>> updateActivity(
    int activityId, {
    String? description,
    String? status,
    String? assignedTo,
    String? priority,
  }) {
    return activityRemoteDataSource.updateActivity(
      activityId,
      description: description,
      status: status,
      assignedTo: assignedTo,
      priority: priority,
    );
  }

  @override
  Future<Either<Failure, String>> deleteActivity(int activityId) {
    return activityRemoteDataSource.deleteActivity(activityId);
  }
}
