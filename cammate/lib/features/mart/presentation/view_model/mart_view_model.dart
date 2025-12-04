// ignore_for_file: use_build_context_synchronously

import 'package:cammate/config/approutes.dart';
import 'package:cammate/core/common/appbar/my_snackbar.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/mart/data/model/mart_model.dart';
import 'package:cammate/features/mart/domain/usecase/mart_use_case.dart';
import 'package:cammate/features/mart/presentation/state/mart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final martViewModelProvider = StateNotifierProvider<MartViewModel, MartState>(
  (ref) => MartViewModel(
    martUseCase: ref.read(martUseCaseProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class MartViewModel extends StateNotifier<MartState> {
  final MartUseCase martUseCase;
  UserSharedPrefs userSharedPrefs;

  MartViewModel({required this.userSharedPrefs, required this.martUseCase})
    : super(MartState.initialState()) {
    // getUserById();
  }

  Future<void> createMart(MartAPIModel mart, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await martUseCase.createMart(mart);
      state = state.copyWith(isLoading: false);
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.error, isLoading: false, showMessage: true);
          showMySnackBar(message: state.error!, context: context, color: Colors.red[900]);
        },
        (success) {
          // On success: notify user, close create screen and refresh the list
          state = state.copyWith(
            isLoading: false,
            message: success.toString(),
            showMessage: true,
            error: null,
          );
          showMySnackBar(message: state.message ?? 'Mart created', context: context);
          Navigator.pop(context); // close create screen
          // refresh the mart list
          Future.microtask(() => fetchAllMarts());
        },
      );
    } catch (e) {
      state = state.copyWith(error: 'Error registering', isLoading: false, showMessage: true);
    }
  }

  // Future<void> verifyEmail(
  //   BuildContext context,
  //   String username,
  //   String otp,
  // ) async {
  //   try {
  //     state = state.copyWith(isLoading: true);
  //     final result = await martUseCase.verifyEmail(username, otp);
  //     state = state.copyWith(isLoading: false);

  //     result.fold(
  //       (failure) {
  //         state = state.copyWith(
  //           error: failure.error,
  //           isLoading: false,
  //           showMessage: true,
  //         );
  //         showMySnackBar(
  //           message: state.error!,
  //           context: context,
  //           color: Colors.red[900],
  //         );
  //       },
  //       (success) {
  //         state = state.copyWith(
  //           isLoading: false,
  //           message: success,
  //           showMessage: true,
  //           error: null,
  //         );
  //         showMySnackBar(message: success, context: context);
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           AppRoute.loginRoute,
  //           (route) => false,
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     state = state.copyWith(
  //       error: 'Error logging in user',
  //       isLoading: false,
  //       showMessage: true,
  //     );
  //   }
  // }

  /// Fetch all marts and update state.marts
  Future<void> fetchAllMarts({int skip = 0, int limit = 100}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final result = await martUseCase.getAllMarts(skip: skip, limit: limit);
      result.fold(
        (failure) {
          state = state.copyWith(isLoading: false, error: failure.error, marts: []);
        },
        (marts) {
          state = state.copyWith(isLoading: false, error: null, marts: marts);
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load marts');
    }
  }

  void logout(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    showMySnackBar(message: 'See you soon. Bye!!', context: context);

    await userSharedPrefs.deleteUserToken();
    Future.delayed(const Duration(milliseconds: 1000), () {
      state = state.copyWith(isLoading: true);
      Navigator.pushNamedAndRemoveUntil(context, AppRoute.loginRoute, (route) => false);
    });
  }

  void resetMessage(bool value) {
    state = state.copyWith(showMessage: false, error: null, isLoading: false);
  }
}
