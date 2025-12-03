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
  // Future<Either<Failure, String>> verifyEmail(String username, String otp);
  Future<Either<Failure, String>> loginUser(String username, String password);
  // Future<Either<Failure, String>> updateUser(
  //   String fullName,
  //   String username,
  //   String address,
  //   String number,
  // );
  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(String email);
  Future<Either<Failure, String>> resetPasswordWithToken(String token, String newPassword);
  Future<Either<Failure, Map<String, dynamic>>> changePassword(String currentPassword,newpassword);
  // Future<Either<Failure, String>> uploadProfilePicture(File file);
  // Future<Either<Failure, String>> requestOTP(String username);
  Future<Either<Failure, String>> resetPassword(String username, String otp, String password);
  // Future<AuthEntity> getUserById();
}
