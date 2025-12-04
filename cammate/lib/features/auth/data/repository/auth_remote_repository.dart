import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/auth/data/datasource/auth_datasource.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:cammate/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteRepoProvider = Provider.autoDispose<IAuthRepository>(
  (ref) => AuthRemoteRepoImpl(authRemoteDataSource: ref.read(authRemoteDataSourceProvider)),
);

class AuthRemoteRepoImpl implements IAuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRemoteRepoImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, String>> registerUser(AuthEntity auth) async {
    final result = await authRemoteDataSource.registerUser(auth);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  // @override
  // Future<Either<Failure, String>> verifyEmail(String username, String otp) async {
  //   final result = await authRemoteDataSource.verifyEmail(username, otp);
  //   return result.fold((failure) => Left(failure), (success) => Right(success));
  // }

  @override
  Future<Either<Failure, String>> loginUser(String username, String password) async {
    final result = await authRemoteDataSource.loginUser(username, password);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  // @override
  // Future<Either<Failure, String>> updateUser(
  //   String fullName,
  //   String username,
  //   String address,
  //   String number,
  // ) async {
  //   final result = await authRemoteDataSource.updateUser(
  //     fullName,
  //     username,
  //     address,
  //     number,
  //   );
  //   return result.fold((failure) => Left(failure), (success) => Right(success));
  // }

  @override
  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(String email) async {
    final result = await authRemoteDataSource.forgotPassword(email);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

   @override
  Future<Either<Failure, Map<String, dynamic>>> changePassword(String currentPassword,newPassword) async {
    final result = await authRemoteDataSource.changePassword(currentPassword,newPassword);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  @override
  Future<Either<Failure, String>> resetPasswordWithToken(String token, String newPassword) async {
    final result = await authRemoteDataSource.resetPasswordWithToken(token, newPassword);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

}
