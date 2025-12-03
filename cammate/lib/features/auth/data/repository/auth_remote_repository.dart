
import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/auth/data/datasource/auth_datasource.dart';
import 'package:cammate/features/auth/domain/entity/auth_entity.dart';
import 'package:cammate/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteRepoProvider = Provider.autoDispose<IAuthRepository>(
  (ref) => AuthRemoteRepoImpl(
    authRemoteDataSource: ref.read(authRemoteDataSourceProvider),
  ),
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
  // Future<Either<Failure, String>> verifyEmail(String email, String otp) async {
  //   final result = await authRemoteDataSource.verifyEmail(email, otp);
  //   return result.fold((failure) => Left(failure), (success) => Right(success));
  // }

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    final result = await authRemoteDataSource.loginUser(email, password);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  // @override
  // Future<Either<Failure, String>> updateUser(
  //   String fullName,
  //   String email,
  //   String address,
  //   String number,
  // ) async {
  //   final result = await authRemoteDataSource.updateUser(
  //     fullName,
  //     email,
  //     address,
  //     number,
  //   );
  //   return result.fold((failure) => Left(failure), (success) => Right(success));
  // }

  @override
  Future<Either<Failure, String>> updateUserPassword(
    String currentPassword,
    String newPassword,
  ) async {
    final result = await authRemoteDataSource.updateUserPassword(
      currentPassword,
      newPassword,
    );
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  // @override
  // Future<Either<Failure, String>> uploadProfilePicture(File file) async {
  //   final result = await authRemoteDataSource.uploadProfilePicture(file);
  //   return result.fold((failure) => Left(failure), (success) => Right(success));
  // }

  // @override
  // Future<Either<Failure, String>> requestOTP(String email) async {
  //   final result = await authRemoteDataSource.requestOTP(email);
  //   return result.fold((failure) => Left(failure), (success) => Right(success));
  // }

  @override
  Future<Either<Failure, String>> resetPassword(
    String email,
    String otp,
    String password,
  ) async {
    final result = await authRemoteDataSource.resetPassword(
      email,
      otp,
      password,
    );
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  // @override
  // Future<AuthEntity> getUserById() {
  //   return authRemoteDataSource.getUserById();
  // }
}
