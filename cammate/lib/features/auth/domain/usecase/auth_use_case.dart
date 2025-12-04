import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:cammate/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUseCaseProvider = Provider.autoDispose<AuthUseCase>(
  (ref) => AuthUseCase(
    repository: ref.read(authRepositoryProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class AuthUseCase {
  final IAuthRepository repository;
  final UserSharedPrefs userSharedPrefs;

  AuthUseCase({required this.repository, required this.userSharedPrefs});

  Future<Either<Failure, String>> registerUser(AuthEntity auth) async {
    return await repository.registerUser(auth);
  }

  Future<Either<Failure, String>> loginUser(String username, String password) async {
    return await repository.loginUser(username, password);
  }

  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(String email) async {
    return await repository.forgotPassword(email);
  }

  Future<Either<Failure, String>> resetPasswordWithToken(String token, String newPassword) async {
    return await repository.resetPasswordWithToken(token, newPassword);
  }

  Future<Either<Failure, Map<String, dynamic>>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    return await repository.changePassword(currentPassword, newPassword);
  }
}
