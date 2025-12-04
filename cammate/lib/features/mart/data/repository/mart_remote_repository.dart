import 'package:cammate/core/failure/failure.dart';
import 'package:cammate/features/mart/data/datasource/mart_datasource.dart';
import 'package:cammate/features/mart/data/model/mart_model.dart';
import 'package:cammate/features/mart/domain/repository/mart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final martRemoteRepoProvider = Provider.autoDispose<IMartRepository>(
  (ref) => MartRemoteRepoImpl(
    martRemoteDataSource: ref.read(martRemoteDataSourceProvider),
  ),
);

class MartRemoteRepoImpl implements IMartRepository {
  final MartRemoteDataSource martRemoteDataSource;

  MartRemoteRepoImpl({required this.martRemoteDataSource});

  @override
  Future<Either<Failure, MartAPIModel>> createMart(MartAPIModel mart) async {
    final result = await martRemoteDataSource.createMart(mart);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  @override
  Future<Either<Failure, List<MartAPIModel>>> getAllMarts({int skip = 0, int limit = 100}) async {
    final result = await martRemoteDataSource.getAllMarts(skip: skip, limit: limit);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  @override
  Future<Either<Failure, MartAPIModel>> getMartById(int martId) async {
    final result = await martRemoteDataSource.getMartById(martId);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  @override
  Future<Either<Failure, MartAPIModel>> updateMart(int martId, MartAPIModel mart) async {
    final result = await martRemoteDataSource.updateMart(martId, mart);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }

  @override
  Future<Either<Failure, String>> deleteMart(int martId) async {
    final result = await martRemoteDataSource.deleteMart(martId);
    return result.fold((failure) => Left(failure), (success) => Right(success));
  }
}
