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

  // Future<Either<Failure, String>> verifyEmail(
  //   String username,
  //   String otp,
  // ) async {
  //   return await repository.verifyEmail(username, otp);
  // }

  Future<Either<Failure, String>> loginUser(String username, String password) async {
    return await repository.loginUser(username, password);
  }

  // Future<Either<Failure, String>> updateUser(
  //     String fullName, String username, String address, String number) async {
  //   return await repository.updateUser(fullName, username, address, number);
  // }

  Future<Either<Failure, String>> updateUserPassword(
    String currentPassword,
    String newPassword,
  ) async {
    return await repository.updateUserPassword(currentPassword, newPassword);
  }

  // Future<Either<Failure, String>> uploadProfilePicture(File? file) async {
  //   if (file == null) {
  //     return Left(Failure(error: "File is null"));
  //   }

  //   return await repository.uploadProfilePicture(file);
  // }

  // Future<Either<Failure, String>> requestOTP(
  //   String username,
  // ) async {
  //   return await repository.requestOTP(username);
  // }

  Future<Either<Failure, String>> resetPassword(
    String username,
    String otp,
    String password,
  ) async {
    return await repository.resetPassword(username, otp, password);
  }

  // Future<AuthEntity> getUserById() async {
  //   return await repository.getUserById();
  // }
}
