import 'package:cammate/features/primary/state/primary_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myPrimaryViewModelProvider =
    StateNotifierProvider.autoDispose<PrimaryViewModel, PrimaryState>(
      (ref) => PrimaryViewModel(),
    );

class PrimaryViewModel extends StateNotifier<PrimaryState> {
  PrimaryViewModel() : super(PrimaryState.initialState()) {
    getAllData();
  }

  void changeIndex(int index) {
    state = state.copyWith(index: index);
  }

  void getAllData() {
    state = state.copyWith(isLoading: true);
  }
}
