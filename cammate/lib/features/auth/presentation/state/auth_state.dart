

import 'package:cammate/features/auth/domain/entity/auth_entity.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool showMessage;
  final String? message;
  final String? imageName;
  final AuthEntity? userDetail;

  AuthState({
    required this.isLoading,
    this.error,
    this.message,
    this.showMessage = false,
    this.imageName,
    this.userDetail,
  });

  factory AuthState.initialState() {
    return AuthState(
      isLoading: false,
      error: null,
      showMessage: false,
      imageName: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? showMessage,
    String? message,
    String? imageName,
    AuthEntity? userDetail,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
      imageName: imageName ?? this.imageName,
      userDetail: userDetail ?? this.userDetail,
    );
  }

  @override
  String toString() => 'AuthState(isLoading: $isLoading, error: $error)';
}