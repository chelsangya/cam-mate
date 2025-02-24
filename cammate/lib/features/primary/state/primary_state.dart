import 'package:cammate/features/primary/view/customer_list.dart';
import 'package:cammate/features/primary/view/dashboard.dart';
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
        const DashboardScreen(),
        const DashboardScreen(),
        const UserList(),
        const DashboardScreen(),
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
