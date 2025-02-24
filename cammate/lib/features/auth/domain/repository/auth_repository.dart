import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/auth/data/repository/auth_remote_repository.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider.autoDispose<IRegisterRepository>(
    (ref) => ref.read(authRemoteRepoProvider));

abstract class IRegisterRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
    Future<Either<Failure, List<String>>> login(String email, String password);
  // Future<Either<Failure, bool>> sendOTP(String number);
}