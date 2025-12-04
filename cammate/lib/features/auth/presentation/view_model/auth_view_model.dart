import 'package:cammate/config/approutes.dart';
import 'package:cammate/core/common/appbar/my_snackbar.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:cammate/features/auth/domain/usecase/auth_use_case.dart';
import 'package:cammate/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
    authUseCase: ref.read(authUseCaseProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthUseCase authUseCase;
  UserSharedPrefs userSharedPrefs;

  AuthViewModel({required this.userSharedPrefs, required this.authUseCase})
    : super(AuthState.initialState()) {
    // getUserById();
  }

  Future<void> registerUser(AuthEntity auth, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await authUseCase.registerUser(auth);
      state = state.copyWith(isLoading: false);
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.error, isLoading: false, showMessage: true);
          showMySnackBar(message: state.error!, context: context, color: Colors.red[900]);
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            message: success,
            showMessage: true,
            error: null,
          );
          showMySnackBar(message: state.message!, context: context);
          Navigator.popAndPushNamed(context, AppRoute.verifyEmailRoute, arguments: auth);
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
  //     final result = await authUseCase.verifyEmail(username, otp);
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

  Future<void> loginUser(BuildContext context, String username, String password) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await authUseCase.loginUser(username, password);
      state = state.copyWith(isLoading: false);

      result.fold(
        (failure) {
          state = state.copyWith(error: 'VM ${failure.error}', isLoading: false, showMessage: true);
          showMySnackBar(message: state.error!, context: context, color: Colors.red[900]);
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            message: success,
            showMessage: true,
            error: null,
          );
          showMySnackBar(message: success, context: context);
          // getUserById();
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.superUserHomeRoute, (route) => false);
        },
      );
    } catch (e) {
      print('Error logging in ${e.toString()}');
      state = state.copyWith(error: 'Error logging in user', isLoading: false, showMessage: true);
    }
  }

  // Future<void> updateUser(
  //   String fullName,
  //   String username,
  //   String address,
  //   String number,
  //   BuildContext context,
  // ) async {
  //   try {
  //     state = state.copyWith(isLoading: true);
  //     final result = await authUseCase.updateUser(
  //       fullName,
  //       username,
  //       address,
  //       number,
  //     );
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
  //         getUserById();
  //         showMySnackBar(message: state.message!, context: context);
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           AppRoute.homeRoute,
  //           (route) => false,
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     state = state.copyWith(
  //       error: 'Error updating',
  //       isLoading: false,
  //       showMessage: true,
  //     );
  //   }
  // }

  /// Requests a password reset for [email].
  /// Returns the backend response map on success (may include a `reset_token`).
  Future<Map<String, dynamic>?> forgotPassword(String email, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await authUseCase.forgotPassword(email);
      state = state.copyWith(isLoading: false);
      return await result.fold(
        (failure) async {
          state = state.copyWith(error: failure.error, isLoading: false, showMessage: true);
          showMySnackBar(message: state.error!, context: context, color: Colors.red[900]);
          return null;
        },
        (success) async {
          // success is a Map<String, dynamic>
          final resp = Map<String, dynamic>.from(success);
          state = state.copyWith(
            isLoading: false,
            message:
                resp['message']?.toString() ?? 'If the email exists, a reset link has been sent.',
            showMessage: true,
            error: null,
          );
          showMySnackBar(message: state.message!, context: context);
          return resp;
        },
      );
    } catch (e) {
      state = state.copyWith(error: 'Error updating password', isLoading: false, showMessage: true);
      return null;
    }
  }

  Future<void> resetPasswordWithToken(
    String token,
    String newPassword,
    BuildContext context,
  ) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await authUseCase.resetPasswordWithToken(token, newPassword);
      state = state.copyWith(isLoading: false);
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.error, isLoading: false, showMessage: true);
          showMySnackBar(message: state.error!, context: context, color: Colors.red[900]);
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            message: success,
            showMessage: true,
            error: null,
          );
          showMySnackBar(message: state.message!, context: context);
          // After resetting password, route user back to login
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.loginRoute, (route) => false);
        },
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error resetting password',
        isLoading: false,
        showMessage: true,
      );
    }
  }

  // Future<void> getUserById() async {
  //   state = state.copyWith(isLoading: true);

  //   final result = await authUseCase.getUserById();

  //   state = state.copyWith(userDetail: result, isLoading: false);
  // }

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
