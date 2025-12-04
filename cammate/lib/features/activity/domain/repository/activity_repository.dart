import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/activity/data/model/activity_model.dart';
import 'package:cammate/features/activity/data/repository/activity_remote_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityRepositoryProvider = Provider.autoDispose<IActivityRepository>(
  (ref) => ref.read(activityRemoteRepoProvider),
);



abstract class IActivityRepository {
  Future<Either<Failure, List<ActivityAPIModel>>> getActivities({
    int? martId,
    String? status,
    String? priority,
    int skip,
    int limit,
  });

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
  });

  Future<Either<Failure, String>> getActivityStats({required int martId});

  Future<Either<Failure, ActivityAPIModel>> getActivityById(int activityId);

  Future<Either<Failure, ActivityAPIModel>> updateActivity(
    int activityId, {
    String? description,
    String? status,
    String? assignedTo,
    String? priority,
  });

  Future<Either<Failure, String>> deleteActivity(int activityId);
}
