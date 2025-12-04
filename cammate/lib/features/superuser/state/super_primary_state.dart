import 'package:cammate/features/auth/presentation/view/profile_view.dart';
import 'package:cammate/features/mart/presentation/view/marts_view.dart';
import 'package:flutter/widgets.dart';

class SuperPrimaryState {
  final int index;
  final bool isLoading;
  // final List<ElementEntity> elements;
  final List<Widget> lstWidgets;

  SuperPrimaryState({
    required this.index,
    required this.lstWidgets,
    required this.isLoading,
    // required this.elements
  });

  SuperPrimaryState.initialState()
    : index = 0,
      isLoading = false,
      // elements = [],
      lstWidgets = [const MartsView(), const MartsView(), const MartsView(), const ProfileView()];

  SuperPrimaryState copyWith({
    int? index,
    bool? isLoading,
    // List<ElementEntity>? elements,
  }) {
    return SuperPrimaryState(
      index: index ?? this.index,
      isLoading: isLoading ?? this.isLoading,
      lstWidgets: lstWidgets,
      // elements: elements ?? this.elements,
    );
  }
}
