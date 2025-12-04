import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/user/data/model/user_model.dart';
import 'package:cammate/features/user/data/repository/user_remote_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider.autoDispose<IUserRepository>(
  (ref) => ref.read(userRemoteRepoProvider as ProviderListenable<IUserRepository>),
);

abstract class IUserRepository {
  /// Create new user
  /// If `password` is provided it will be sent to the backend during creation.
  Future<Either<Failure, UserAPIModel>> createUser(UserAPIModel user, {String? password});

  /// Get all users with pagination
  Future<Either<Failure, List<UserAPIModel>>> getAllUsers({int skip, int limit});

  /// Get single user by ID
  Future<Either<Failure, UserAPIModel>> getUserById(int userId);

  /// Update existing user
  Future<Either<Failure, UserAPIModel>> updateUser(
    int userId,
    UserAPIModel user, {
    String? password,
  });
}
