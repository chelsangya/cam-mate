import 'package:cammate/features/superuser/state/super_primary_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final primaryViewModelProvider =
    StateNotifierProvider.autoDispose<SuperPrimaryViewModel, SuperPrimaryState>(
      (ref) => SuperPrimaryViewModel(),
    );

class SuperPrimaryViewModel extends StateNotifier<SuperPrimaryState> {
  SuperPrimaryViewModel() : super(SuperPrimaryState.initialState()) {
    getAllData();
  }

  void changeIndex(int index) {
    state = state.copyWith(index: index);
  }

  void getAllData() {
    state = state.copyWith(isLoading: true);
  }
}
