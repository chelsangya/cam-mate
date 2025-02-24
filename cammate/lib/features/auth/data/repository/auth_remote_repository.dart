import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/auth/data/datasource/auth_datasource.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:cammate/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteRepoProvider = Provider.autoDispose<IRegisterRepository>(
  (ref) => RegisterRemoteRepoImpl(
    authRemoteDataSource: ref.read(authRemoteDataSourceProvider),
  ),
);

class RegisterRemoteRepoImpl implements IRegisterRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  RegisterRemoteRepoImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) {
    return authRemoteDataSource.register(user);
  }

   @override
  Future<Either<Failure, List<String>>> login(String email, String password) {
    return authRemoteDataSource.login(email, password);
  }
}