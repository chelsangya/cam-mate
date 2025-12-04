// ignore_for_file: use_build_context_synchronously

import 'package:cammate/config/approutes.dart';
import 'package:cammate/core/common/appbar/my_snackbar.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/user/data/model/user_model.dart';
import 'package:cammate/features/user/domain/usecase/user_use_case.dart';
import 'package:cammate/features/user/presentation/state/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>(
  (ref) => UserViewModel(
    userUseCase: ref.read(userUseCaseProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class UserViewModel extends StateNotifier<UserState> {
  final UserUseCase userUseCase;
  UserSharedPrefs userSharedPrefs;

  UserViewModel({required this.userSharedPrefs, required this.userUseCase})
    : super(UserState.initialState()) {
    // getUserById();
  }

  Future<void> createUser(UserAPIModel user, BuildContext context, {String? password}) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await userUseCase.createUser(user, password: password);
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
          showMySnackBar(message: state.message ?? 'User created', context: context);
          Navigator.pop(context); // close create screen
          // refresh the user list
          Future.microtask(() => fetchAllUsers());
        },
      );
    } catch (e) {
      state = state.copyWith(error: 'Error registering', isLoading: false, showMessage: true);
    }
  }

  Future<bool> updateUser(int userId, UserAPIModel user, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await userUseCase.updateUser(userId, user);
      state = state.copyWith(isLoading: false);
      var successFlag = false;
      result.fold(
        (failure) {
          // prefer a friendly fallback message when the backend message is empty
          final msg =
              (failure.error.isNotEmpty)
                  ? failure.error
                  : 'Could not update user. Please try again later.';
          state = state.copyWith(error: msg, isLoading: false, showMessage: true, message: msg);
          // UI (UsersView / Detail view) will show the snackbar from state.message
          successFlag = false;
        },
        (updated) {
          final msg = 'User updated';
          state = state.copyWith(isLoading: false, message: msg, showMessage: true, error: null);
          // refresh list
          Future.microtask(() => fetchAllUsers());
          successFlag = true;
        },
      );
      return successFlag;
    } catch (e) {
      state = state.copyWith(error: 'Error updating user', isLoading: false, showMessage: true);
      return false;
    }
  }

  // Future<void> verifyEmail(
  //   BuildContext context,
  //   String username,
  //   String otp,
  // ) async {
  //   try {
  //     state = state.copyWith(isLoading: true);
  //     final result = await userUseCase.verifyEmail(username, otp);
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

  Future<void> fetchAllUsers({int skip = 0, int limit = 100}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final result = await userUseCase.getAllUsers(skip: skip, limit: limit);
      result.fold(
        (failure) {
          // Preserve existing users on failure so UI can continue to show cached list.
          state = state.copyWith(
            isLoading: false,
            error: failure.error,
            showMessage: true,
            message: failure.error,
          );
        },
        (users) {
          state = state.copyWith(isLoading: false, error: null, users: users);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load users',
        showMessage: true,
        message: 'Failed to load users',
      );
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
    void checkRefresh(BuildContext context, String message) {
    if (message.contains("Token has expired") ||
        message.contains("Token expired and refresh failed") ||
        message.contains("Invalid token")) {
      // show snackbar
      showMySnackBar(context: context, message: "The session has expired. Please log in again.");
      logout(context);
    }
  }

  void resetMessage(bool value) {
    state = state.copyWith(showMessage: false, error: null, isLoading: false);
  }
}
