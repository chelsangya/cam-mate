import 'dart:io';

import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/auth/data/repository/auth_remote_repository.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider.autoDispose<IAuthRepository>(
  (ref) => ref.read(authRemoteRepoProvider),
);

abstract class IAuthRepository {
  // Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, String>> registerUser(AuthEntity auth);
  Future<Either<Failure, String>> verifyEmail(String email, String otp);
  Future<Either<Failure, String>> loginUser(String email, String password);
  Future<Either<Failure, String>> updateUser(
    String fullName,
    String email,
    String address,
    String number,
  );
  Future<Either<Failure, String>> updateUserPassword(
    String currentPassword,
    String newPassword,
  );
  Future<Either<Failure, String>> uploadProfilePicture(File file);
  Future<Either<Failure, String>> requestOTP(String email);
  Future<Either<Failure, String>> resetPassword(
    String email,
    String otp,
    String password,
  );
  Future<AuthEntity> getUserById();
}
