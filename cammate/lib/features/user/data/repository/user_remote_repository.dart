import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/user/data/datasource/user_datasource.dart';
import 'package:cammate/features/user/data/model/user_model.dart';
import 'package:cammate/features/user/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRemoteRepoProvider = Provider.autoDispose<IUserRepository>(
  (ref) => UserRemoteRepoImpl(userRemoteDataSource: ref.read(userRemoteDataSourceProvider)),
);

class UserRemoteRepoImpl implements IUserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRemoteRepoImpl({required this.userRemoteDataSource});

  @override
  Future<Either<Failure, UserAPIModel>> createUser(UserAPIModel user, {String? password}) {
    return userRemoteDataSource.createUser(user, password: password);
  }

  @override
  Future<Either<Failure, List<UserAPIModel>>> getAllUsers({int skip = 0, int limit = 100}) {
    return userRemoteDataSource.getAllUsers(skip: skip, limit: limit);
  }

  @override
  Future<Either<Failure, UserAPIModel>> getUserById(int userId) {
    return userRemoteDataSource.getUserById(userId);
  }

  @override
  Future<Either<Failure, UserAPIModel>> updateUser(
    int userId,
    UserAPIModel user, {
    String? password,
  }) {
    return userRemoteDataSource.updateUser(userId, user, password: password);
  }
}
