import 'package:cammate/config/approutes.dart';
// snackbar UI is handled by views; viewmodels only set state.message/showMessage
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
          state = state.copyWith(
            error: failure.error,
            isLoading: false,
            showMessage: true,
            message: failure.error,
          );
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            message: success,
            showMessage: true,
            error: null,
          );
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
          print('Login failed: ${failure.error}');
          String msg;
          if (failure.error.contains("Unauthorized")) {
            msg = "Invalid username or password";
          } else {
            msg = "Login failed. Please try again later.";
          }
          state = state.copyWith(
            error: msg,
            isLoading: false,
            showMessage: true,
            message: 'Login failed',
          );
        },
        (success) {
          state = state.copyWith(
            isLoading: false,
            message: success,
            showMessage: true,
            error: null,
          );
          // getUserById();
          // userSharedPrefs.getUserRole() returns a Future<Either<Failure, String?>>
          // so unwrap it asynchronously and then navigate based on role value.
          userSharedPrefs.getUserRole().then((roleEither) {
            roleEither.fold(
              (failure) {
                // couldn't read role; fall back to default route
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.superUserHomeRoute,
                  (route) => false,
                );
              },
              (role) {
                final lower = role?.toLowerCase() ?? '';
                if (lower == 'superuser') {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoute.superUserHomeRoute, (route) => false);
                  return;
                }
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.superUserHomeRoute,
                  (route) => false,
                );
              },
            );
          });
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

  Future<Map<String, dynamic>?> forgotPassword(String email, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await authUseCase.forgotPassword(email);
      state = state.copyWith(isLoading: false);
      return await result.fold(
        (failure) async {
          state = state.copyWith(
            error: failure.error,
            isLoading: false,
            showMessage: true,
            message: failure.error,
          );
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
      final msg = 'Password has been reset successfully';
      state = state.copyWith(isLoading: false);
      result.fold(
        (failure) async {
          state = state.copyWith(
            error: failure.error,
            isLoading: false,
            showMessage: true,
            message: failure.error,
          );
          await Future.delayed(Duration.zero);
        },
        (success) async {
          print('Reset password success: $success');
          state = state.copyWith(isLoading: false, message: msg, showMessage: true, error: null);
          await Future.delayed(Duration.zero);
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
          checkRefresh(context, failure.error);
          final msg =
              (failure.error.isNotEmpty)
                  ? failure.error
                  : 'Could not change password. Please try again later.';
          state = state.copyWith(error: msg, isLoading: false, showMessage: true, message: msg);
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
          // After changing password, it's reasonable to navigate back to profile/login
          Navigator.pop(context);
          // show message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
        },
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error changing password',
        isLoading: false,
        showMessage: true,
        message: 'Error changing password',
      );
    }
  }

  // Future<void> getUserById() async {
  //   state = state.copyWith(isLoading: true);

  //   final result = await authUseCase.getUserById();

  //   state = state.copyWith(userDetail: result, isLoading: false);
  // }

  void logout(BuildContext context) async {
    // show a brief loading state, clear tokens, then navigate to login
    state = state.copyWith(isLoading: true, showMessage: true, message: 'See you soon. Bye!!');

    await userSharedPrefs.deleteUserToken();
    Future.delayed(const Duration(milliseconds: 1000), () {
      // stop loading before navigating so the login screen doesn't inherit a spinning state
      state = state.copyWith(isLoading: false, showMessage: false, error: null);
      Navigator.pushNamedAndRemoveUntil(context, AppRoute.loginRoute, (route) => false);
      // show a snackbar with the message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logged out successfully")));
    });
  }

  void checkRefresh(BuildContext context, String message) {
    if (message.contains("Token expired") ||
        message.contains("Token expired and refresh failed") ||
        message.contains("Invalid token")) {
      // set a message and logout; UI can choose how to show it
      state = state.copyWith(
        showMessage: true,
        message: "The session has expired. Please log in again.",
      );
      logout(context);
    }
  }

  void resetMessage(bool value) {
    state = state.copyWith(showMessage: false, error: null, isLoading: false);
  }
}
