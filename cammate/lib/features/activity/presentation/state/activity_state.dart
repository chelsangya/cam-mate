import 'package:cammate/features/activity/data/model/activity_model.dart';

class ActivityState {
  final bool isLoading;
  final String? error;
  final bool showMessage;
  final String? message;
  final List<ActivityAPIModel> activities;
  final ActivityAPIModel? selectedActivity;

  ActivityState({
    required this.isLoading,
    this.error,
    this.message,
    this.showMessage = false,
    this.activities = const [],
    this.selectedActivity,
  });

  factory ActivityState.initialState() {
    return ActivityState(isLoading: false, error: null, showMessage: false, activities: const []);
  }

  ActivityState copyWith({
    bool? isLoading,
    String? error,
    bool? showMessage,
    String? message,
    List<ActivityAPIModel>? activities,
    ActivityAPIModel? selectedActivity,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
      activities: activities ?? this.activities,
      selectedActivity: selectedActivity ?? this.selectedActivity,
    );
  }

  @override
  String toString() =>
      'ActivityState(isLoading: $isLoading, error: $error, activities: ${activities.length})';
}
