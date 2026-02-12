import 'package:cammate/features/activity/presentation/view/activity_view.dart';
import 'package:cammate/features/auth/presentation/view/profile_view.dart';
import 'package:cammate/features/mart/presentation/view/marts_view.dart';
import 'package:cammate/features/user/presentation/view/users_view.dart';
import 'package:flutter/widgets.dart';

class PrimaryState {
  final int index;
  final bool isLoading;
  // final List<ElementEntity> elements;
  final List<Widget> lstWidgets;

  PrimaryState({
    required this.index,
    required this.lstWidgets,
    required this.isLoading,
    // required this.elements
  });

  PrimaryState.initialState()
    : index = 0,
      isLoading = false,
      // elements = [],
      lstWidgets = [
        const MartsView(),
        const UsersView(),
        const ActivitiesView(),
        const ProfileView(),
      ];

  PrimaryState copyWith({
    int? index,
    bool? isLoading,
    // List<ElementEntity>? elements,
  }) {
    return PrimaryState(
      index: index ?? this.index,
      isLoading: isLoading ?? this.isLoading,
      lstWidgets: lstWidgets,
      // elements: elements ?? this.elements,
    );
  }
}
