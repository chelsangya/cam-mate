import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/auth/data/repository/auth_remote_repository.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider.autoDispose<IAuthRepository>(
  (ref) => ref.read(authRemoteRepoProvider),
);

abstract class IAuthRepository {
  Future<Either<Failure, String>> registerUser(AuthEntity auth);
  Future<Either<Failure, String>> loginUser(String username, String password);
  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(String email);
  Future<Either<Failure, String>> resetPasswordWithToken(String token, String newPassword);
  Future<Either<Failure, Map<String, dynamic>>> changePassword(String currentPassword,newpassword);

}
