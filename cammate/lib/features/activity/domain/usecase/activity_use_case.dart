import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/activity/data/model/activity_model.dart';
import 'package:cammate/features/activity/domain/repository/activity_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityUseCaseProvider = Provider.autoDispose<ActivityUseCase>(
  (ref) => ActivityUseCase(
    repository: ref.read(activityRepositoryProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class ActivityUseCase {
  final IActivityRepository repository;
  final UserSharedPrefs userSharedPrefs;

  ActivityUseCase({
    required this.repository,
    required this.userSharedPrefs,
  });

  Future<Either<Failure, List<ActivityAPIModel>>> getActivities({
    int? martId,
    String? status,
    String? priority,
    int skip = 0,
    int limit = 100,
  }) {
    return repository.getActivities(
      martId: martId,
      status: status,
      priority: priority,
      skip: skip,
      limit: limit,
    );
  }

  Future<Either<Failure, ActivityAPIModel>> getActivityById(int activityId) {
    return repository.getActivityById(activityId);
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
  }) {
    return repository.createActivity(
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

  Future<Either<Failure, ActivityAPIModel>> updateActivity(
    int activityId, {
    String? description,
    String? status,
    String? assignedTo,
    String? priority,
  }) {
    return repository.updateActivity(
      activityId,
      description: description,
      status: status,
      assignedTo: assignedTo,
      priority: priority,
    );
  }

  Future<Either<Failure, String>> deleteActivity(int activityId) {
    return repository.deleteActivity(activityId);
  }

  Future<Either<Failure, String>> getActivityStats({required int martId}) {
    return repository.getActivityStats(martId: martId);
  }
}
