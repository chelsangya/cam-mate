import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/core/shared_pref/user_shared_prefs.dart';
import 'package:cammate/features/user/data/model/user_model.dart';
import 'package:cammate/features/user/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userUseCaseProvider = Provider.autoDispose<UserUseCase>(
  (ref) => UserUseCase(
    repository: ref.read(userRepositoryProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class UserUseCase {
  final IUserRepository repository;
  final UserSharedPrefs userSharedPrefs;

  UserUseCase({required this.repository, required this.userSharedPrefs});

  /// Create a new user (requires valid token)
  Future<Either<Failure, UserAPIModel>> createUser(UserAPIModel user, {String? password}) async {
    final tokenEither = await userSharedPrefs.getUserToken();
    final token = tokenEither.fold((_) => null, (t) => t);

    if (token == null || token.isEmpty) {
      return Left(Failure(error: 'User is not authenticated', statusCode: 401));
    }

    return repository.createUser(user, password: password);
  }

  /// Get all users with optional pagination
  Future<Either<Failure, List<UserAPIModel>>> getAllUsers({int skip = 0, int limit = 100}) async {
    return repository.getAllUsers(skip: skip, limit: limit);
  }

  /// Get a user by ID
  Future<Either<Failure, UserAPIModel>> getUserById(int userId) async {
    return repository.getUserById(userId);
  }

  /// Update a user by ID, optionally updating the password
  Future<Either<Failure, UserAPIModel>> updateUser(
    int userId,
    UserAPIModel user, {
    String? password,
  }) async {
    return repository.updateUser(userId, user, password: password);
  }
}
