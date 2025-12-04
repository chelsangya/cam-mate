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
          final role = userSharedPrefs.getUserRole();
          if (role == 'superuser' || role == 'SUPERUSER') {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoute.superUserHomeRoute, (route) => false);
            return;
          }
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

  /// Change password for the currently authenticated user.
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    BuildContext context,
  ) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await authUseCase.changePassword(currentPassword, newPassword);
      state = state.copyWith(isLoading: false);
      result.fold(
        (failure) {
          final msg =
              (failure.error.isNotEmpty)
                  ? failure.error
                  : 'Could not change password. Please try again later.';
          state = state.copyWith(error: msg, isLoading: false, showMessage: true, message: msg);
          showMySnackBar(message: msg, context: context, color: Colors.red[900]);
        },
        (successMap) {
          // successMap may contain a message
          final message = successMap['message']?.toString() ?? 'Password changed successfully';
          state = state.copyWith(
            isLoading: false,
            message: message,
            showMessage: true,
            error: null,
          );
          showMySnackBar(message: message, context: context);
          // After changing password, it's reasonable to navigate back to profile/login
          Navigator.pop(context);
        },
      );
    } catch (e) {
      state = state.copyWith(error: 'Error changing password', isLoading: false, showMessage: true);
      showMySnackBar(message: 'Error changing password', context: context, color: Colors.red[900]);
    }
  }

  // Future<void> getUserById() async {
  //   state = state.copyWith(isLoading: true);

  //   final result = await authUseCase.getUserById();

  //   state = state.copyWith(userDetail: result, isLoading: false);
  // }

  void logout(BuildContext context) async {
    // show a brief loading state, clear tokens, then navigate to login
    state = state.copyWith(isLoading: true);

    showMySnackBar(message: 'See you soon. Bye!!', context: context);

    await userSharedPrefs.deleteUserToken();
    Future.delayed(const Duration(milliseconds: 1000), () {
      // stop loading before navigating so the login screen doesn't inherit a spinning state
      state = state.copyWith(isLoading: false, showMessage: false, error: null);
      Navigator.pushNamedAndRemoveUntil(context, AppRoute.loginRoute, (route) => false);
    });
  }

  void resetMessage(bool value) {
    state = state.copyWith(showMessage: false, error: null, isLoading: false);
  }
}
