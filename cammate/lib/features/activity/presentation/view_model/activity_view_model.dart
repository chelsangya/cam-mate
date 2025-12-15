// ignore_for_file: use_build_context_synchronously

import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/activity/domain/usecase/activity_use_case.dart';
import 'package:cammate/features/activity/presentation/state/activity_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityViewModelProvider = StateNotifierProvider<ActivityViewModel, ActivityState>(
  (ref) => ActivityViewModel(
    activityUseCase: ref.read(activityUseCaseProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class ActivityViewModel extends StateNotifier<ActivityState> {
  final ActivityUseCase activityUseCase;
  final UserSharedPrefs userSharedPrefs;

  ActivityViewModel({required this.activityUseCase, required this.userSharedPrefs})
    : super(ActivityState.initialState());

  Future<void> fetchActivities({
    int? martId,
    String? status,
    String? priority,
    BuildContext? context,
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final result = await activityUseCase.getActivities(
        martId: martId,
        status: status,
        priority: priority,
        skip: skip,
        limit: limit,
      );
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.error,
            showMessage: true,
            message: 'Failed to load activities',
          );
        },
        (activities) {
          state = state.copyWith(isLoading: false, error: null, activities: activities);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load activities',
        showMessage: true,
        message: 'Failed to load activities',
      );
    }
  }

  Future<void> createActivity({
    required int cameraId,
    required String activityType,
    required String description,
    required double confidence,
    String? status,
    String? videoClip,
    String? imageUrl,
    String? assignedTo,
    String? priority,
    BuildContext? context,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await activityUseCase.createActivity(
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
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.error,
            showMessage: true,
            message: failure.error,
          );
        },
        (activity) {
          state = state.copyWith(isLoading: false, message: 'Activity created', showMessage: true);
          if (context != null) Navigator.pop(context);
          Future.microtask(() => fetchActivities());
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error creating activity', showMessage: true);
    }
  }

  Future<bool> updateActivity(
    int activityId, {
    String? description,
    String? status,
    String? assignedTo,
    String? priority,
    BuildContext? context,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await activityUseCase.updateActivity(
        activityId,
        description: description,
        status: status,
        assignedTo: assignedTo,
        priority: priority,
      );
      var success = false;
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.error,
            showMessage: true,
            message: failure.error,
          );
          success = false;
        },
        (activity) {
          state = state.copyWith(isLoading: false, message: 'Activity updated', showMessage: true);
          Future.microtask(() => fetchActivities());
          success = true;
        },
      );
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error updating activity', showMessage: true);
      return false;
    }
  }

  Future<void> deleteActivity(int activityId, {BuildContext? context}) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await activityUseCase.deleteActivity(activityId);
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.error,
            showMessage: true,
            message: failure.error,
          );
        },
        (msg) {
          state = state.copyWith(isLoading: false, message: msg, showMessage: true);
          Future.microtask(() => fetchActivities());
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error deleting activity', showMessage: true);
    }
  }

  void resetMessage(bool value) {
    state = state.copyWith(showMessage: false, error: null, isLoading: false);
  }
}
